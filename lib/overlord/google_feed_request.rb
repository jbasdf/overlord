module Overlord
  # Google ajax feed api reference:
  # http://code.google.com/apis/ajaxfeeds/documentation/reference.html
  #
  # Google code playground:
  # http://code.google.com/apis/ajax/playground/?exp=search#load_feed
  #
  class GoogleFeedRequest
    include HTTParty
    format :json
  
    # Initialize Google Request.
    # Parameters:
    # api_key_id:     Valid Google access key (optional)
    def initialize(api_key_id = nil)
      @api_key_id = api_key_id
    end
  
    # Lookup a given feed.  
    def self.lookup_feed(uri)
      get('http://ajax.googleapis.com/ajax/services/feed/lookup', :query => build_google_query({:q => uri}))
    end
  
    # Requests entries for a single feed
    #
    # uri:             Uri of the feed to load
    # number_of_items: Number of items to load from the feed
    def self.load_feed(uri, number_of_items = 5)
      get('http://ajax.googleapis.com/ajax/services/feed/load', :query => build_google_query({:q => uri, :num => number_of_items}))
    end
  
    # Requests a set of feeds from Google
    #
    # feeds:  An array of objects with the attributes 'uri' and 'service_id' defined
    def self.load_feeds(feeds, number_of_items = 5)
      feeds = feeds.collect do |feed|
        json = load_feed(feed.uri, number_of_items)
        new_feed = convert_google_feed_json_to_feed(feed, json)
        new_feed.entries << convert_google_feed_json_to_entries(new_feed, json).compact if new_feed
        new_feed
      end
      if feeds
        feeds.compact
      else
        []
      end
    end
  
    # Converts json returned from google into a feed object
    def self.convert_google_feed_json_to_feed(feed, json)
      if json['responseStatus'] == 200
        if json['responseData']['feed']
          Feed.new( :uri => feed.uri,
                    :service_id => feed.service_id,
                    :display_uri => json['responseData']['feed']['link'],
                    :title => json['responseData']['feed']['title'],
                    :service => feed.service)
        end
      end
    end
  
    # Converts json returned from google into an array of entries
    def self.convert_google_feed_json_to_entries(feed, json)
      if json['responseData']['feed']['entries']
        json['responseData']['feed']['entries'].collect do |entry|
          published_at = DateTime.parse(entry['publishedDate']) rescue DateTime.now - 1.day
          Entry.new(:permalink => entry['link'],
                    :author => entry['author'],
                    :title => entry['title'],
                    :description => entry['contentSnippet'],
                    :content => entry['content'],
                    :published_at => published_at,
                    :tag_list => entry['categories'],
                    :direct_link => entry['link'],
                    :feed => feed)
        end
      end
    end
  
    # Search for feeds using google.  This will return 
    # a collection of 'Feed' objects
    def self.find_feeds(query)
      query = query.join('+') if query.is_a?(Array)
      feed_response = find_google_feeds(query)
      if 200 == feed_response['responseStatus']
        convert_google_find_feeds_json_to_feeds(feed_response)
      else
        []
      end
    end
  
    # Search for feeds using google.  This will return 
    # a hash with the results
    def self.find_google_feeds(query, number_of_items = 5)
      get('http://ajax.googleapis.com/ajax/services/feed/find', :query => build_google_query({:q => query}))
    end
  
    # convert the result of a google query to 'Feed' objects
    def self.convert_google_find_feeds_json_to_feeds(google_feeds)
      google_feeds['responseData']['entries'].collect do |google_feed|
        Feed.new( :uri => google_feed['url'],
                  :display_uri => google_feed['link'],
                  :title => google_feed['title'],
                  :service_id => Service.find_service_by_uri(google_feed['link']).id)
      end
    end

    # Add standard items to the google query
    def self.build_google_query(query_options)
      query_options[:v] = '1.0'
      query_options[:key] = GlobalConfig.google_ajax_api_key if GlobalConfig.google_ajax_api_key
      query_options
    end
  
  end
end