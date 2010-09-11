Overlord.configure do |config|
  config.google_ajax_api_key = ''         # A google ajax api key - http://code.google.com/apis/ajaxsearch/signup.html
  config.request_referer = ''             # The url of the site making the request.
  config.show_google_search = true        # Determines whether or not a google search is displayed on the topic page
  config.load_feeds_on_server = false     # Determines whether feeds on a topic page are loaded on the server or the client.  Loading on the server can take a while
  config.combine_feeds_on_server = false  # Combines feeds loaded on the server
  config.google_ad_partner_pub = nil
end