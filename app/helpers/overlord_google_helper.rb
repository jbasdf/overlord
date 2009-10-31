module OverlordGoogleHelper

  # Render a google custom search control.  If feeds are provided then the search will be restricted to the
  # 'display_url' for each feed.  If search_for is specified then a default search will be executed.
  # It is not recommended that you provide feeds and locale since the overlap between the feeds provided
  # and the languages might be nothing.
  # Examples:
  #
  # Create a custom search over a specific set of feeds:
  # <%= google_search('Google Search (Search within these results)', [], '', %w{web}, 'google_restricted_search') %>
  #
  # Create a general google search based on the current locale:
  # <%= google_search('Google Search', [], @terms, %w{web video blog news image local book patent}, 'google_search', I18n.locale) %>
  #
  # feeds:      An array of feeds to render each with a property 'display_uri' defined
  # search_for: Terms to search for by default.  If none are specified then no default search will be performed.
  # search_types: Types of google searches to add to the dialog. Valid values are web video blog news image local book patent
  # content_id: Name of the div that will hold the widget google generates.
  #             If this method is called more than once on a given page then you will need to 
  #             specify different content_ids for each call.
  # locale:     Locale to restrict searches.  For example, to restrict the search to only German sites specify 'de'
  #             A complete set of valid Google languages can be found here:
  #             http://code.google.com/apis/ajaxlanguage/documentation/#SupportedLanguages
  #             For a list of valid codes you can also look at the babelphish gem.  Codes can be found in languages.rb.
  def google_search(title, feeds = [], search_for = '', search_types = %w{web video blog news image local book patent}, content_id = 'google_search', locale = nil)
    render :partial => 'google/search', :locals => { :title => title,
                                                     :feeds => feeds,
                                                     :search_for => search_for,
                                                     :search_types => search_types,
                                                     :content_id => content_id,
                                                     :locale => locale }
  end
  
  # Utility method for generating scripts required to to build google search
  # type:       Type of Google search.  Should be one of web video blog news image local book patent
  # feeds:      An array of feeds to render each with a property 'display_uri' defined
  # locale:     Locale to restrict searches.  For example, to restrict the search to only German sites specify 'de'
  #             A complete set of valid Google languages can be found here:
  #             http://code.google.com/apis/ajaxlanguage/documentation/#SupportedLanguages
  #             For a list of valid codes you can also look at the babelphish gem.  Codes can be found in languages.rb.
  def google_typed_search(type, feeds = [], locale = nil)
    content = "var #{type}Search = new google.search.#{type.capitalize}Search();\n"
    if !['video', 'blog'].include?(type)
      if !locale.blank?
        content << "#{type}Search.setRestriction(google.search.Search.RESTRICT_EXTENDED_ARGS, {lr:'lang_#{locale}'});\n"
      end
    end
    if !['video', 'local', 'patent', 'book'].include?(type)
      feeds.each do |feed|
        if !feed.display_uri.blank?
          content << "#{type}Search.setSiteRestriction('#{feed.display_uri}');\n"
        end
      end
    end
    content << "searchControl.addSearcher(#{type}Search);\n"
  end
  
  # Render feeds using Google's api
  # feeds:            Feed object.
  # show_controls:    Indicates whether or not to show editing controls. ie Remove
  # number_of_items:  Number of items to display for the given feed.
  # number_of_images: Number of images to get from the feed.
  # number_of_videos: Number of videos to get from the feed.
  # use_uri_for_control: If set to true then a hidden field will be generated containing the feed's uri.  If false then the hidden field will contain the feed's service id.  This is used to
  #                      regenerate the feed after submission to the server.
  # javascript_callback: Name of a javascript method to call after the feed has finished loading.  The 
  #                      method should accept the feed uri and the content id. ie  feed_callback(uri, content_id).
  def google_feeds(feeds, show_controls = false, number_of_items = 6, number_of_images = 20, number_of_videos = 6, 
                  use_uri_for_control = false, run_load_scripts = false, javascript_callback = 'google_load_complete')
    render :partial => 'google/feed', :collection => feeds, :locals => {:number_of_items => number_of_items,
                                                                       :number_of_images => number_of_images,
                                                                       :number_of_videos => number_of_videos,
                                                                       :javascript_callback => javascript_callback,
                                                                       :show_controls => show_controls,
                                                                       :use_uri_for_control => use_uri_for_control,
                                                                       :run_load_scripts => run_load_scripts}
  end

  # Render combined feed using Google's api
  #
  # feeds:               Array of feeds that have attribute 'uri' defined.
  # content_id:          Name of the div that will hold the widget google generates.  
  #                      If this method is called more than once on a given page then you will need to 
  #                      specify different content_ids for each call.
  # javascript_callback: Name of a javascript method to call after the feed has finished loading.  The 
  #                      method should accept the feed uri and the content id. ie  feed_callback(uri, content_id).
  def google_combined_feeds(feeds, content_id = 'google_combined_feed', javascript_callback = nil)
    render :partial => 'google/combined_feed', :locals => { :feeds => feeds, :content_id => content_id, :javascript_callback => javascript_callback }
  end
  
  # Render a google dynamic feed control.
  #
  # feeds:      An array of feeds to render each with a property 'title' and 'uri' defined
  # content_id: Name of the div that will hold the widget google generates.  
  #             If this method is called more than once on a given page then you will need to 
  #             specify different content_ids for each call.
  # options:    A hash containing the values to pass to the Google widget. The available options are defined here:
  #             http://www.google.com/uds/solutions/dynamicfeed/reference.html.
  def google_dynamic_feeds_vertical(feeds, 
                                    content_id = 'dynamic_feed_vertical_content', 
                                    options = { :numResults => 20, :stacked => true, :horizontal => false })
    render :partial => 'google/dynamic_feeds_vertical', :locals => { :feeds => feeds, :content_id => content_id, :options => options }
  end
  
  # Find and output feeds related to the given query
  #
  # query:      A tag or search query to pass to Google.  Google will find feeds that match this value.
  # content_id: Name of the div that will hold the widget google generates.  
  #             If this method is called more than once on a given page then you will need to 
  #             specify different content_ids for each call.
  def google_feed_search(query, content_id = 'feed_search_content')
    render :partial => 'google/feed_search', :locals => { :query => query, :content_id => content_id }
  end
  
  # Generate a slide show from a feed
  # feed:       Url for which to generate the feed.
  # content_id: Name of the div that will hold the widget google generates.
  #             If this method is called more than once on a given page then you will need to 
  #             specify different content_ids for each call.
  # options:    A hash containing the values to pass to the Google widget. The available options are defined here:
  #             http://www.google.com/uds/solutions/slideshow/index.html
  def google_slide_show(feed, 
                        content_id = 'slide_show_content',
                        options = { :displayTime => 2000, :transistionTime => 600, :scaleImages => true, :fullControlPanel => true })
    render :partial => 'google/slide_show', :locals => { :feed => feed, :content_id => content_id, :options => options }
  end

  # Given a feed attempts to assign an appropriate class
  def feed_class(feed)
    return '' if feed.service.blank?
    
    if feed.service.photo?
      "feed-photos"
    elsif feed.service.bookmark?
      "feed-bookmarks"
    elsif feed.service.video?
      "feed-videos"
    elsif feed.service.music?
      "feed-music"
    end
  end
  
  # Generates a valid dom id for the feed
  def feed_content_id(feed)
    "feed_#{feed.id}_#{feed.title.parameterize}_#{feed.service.name.parameterize}".gsub('+', '-')
  end
  
  # Outputs the appropriate script for handling the google response once the feed is loaded
  # feed:             Url for which to generate the feed.
  # content_id:       Name of the div that will hold the widget google generates.  
  #                   If this method is called more than once on a given page then you will need to 
  #                   specify different content_ids for each call.
  # javascript_callback: Name of a javascript method to call after the feed has finished loading.  The 
  #                      method should accept the feed uri and the content id. ie  feed_callback(uri, content_id).
  def google_muck_load_script(feed, content_id = nil, javascript_callback = nil)
    if feed.service.blank?
      google_load_entries_script(javascript_callback, feed.uri, content_id)
    else      
      if feed.service.photo?
        google_load_images_script(javascript_callback, feed.uri, content_id)
      elsif feed.service.bookmark?
        google_load_bookmarks_script(javascript_callback, feed.uri, content_id)
      elsif feed.service.video?
        google_load_videos_script(javascript_callback, feed.uri, content_id)
      elsif feed.service.music?
        # TODO need to get music feeds into tag system so that we can search for music feeds and then integrate in a way that can play the tunes.
        google_load_entries_script(javascript_callback, feed.uri, content_id)
      else 
        google_load_entries_script(javascript_callback, feed.uri, content_id)
      end
    end
  end
  
  def google_muck_load_callback_script(feed, content_id, number_of_items = 4, number_of_images = 6, number_of_videos = 6)
    if feed.service.blank?
      "google_load_entries('#{feed.uri}', '#{content_id}', #{number_of_items});"
    else
      if feed.service.photo?
        "google_load_images('#{feed.uri}', '#{content_id}', #{number_of_images});"
      elsif feed.service.bookmark?
        "google_load_bookmarks('#{feed.uri}', '#{content_id}', #{number_of_items});"
      elsif feed.service.video?
        "google_load_videos('#{feed.uri}', '#{content_id}', #{number_of_videos});"
      elsif feed.service.music?
        "google_load_entries('#{feed.uri}', '#{content_id}', #{number_of_items});"
      else
        "google_load_entries('#{feed.uri}', '#{content_id}', #{number_of_items});"
      end
    end
  end
  
  def google_load_videos_script(javascript_callback, uri, content_id)
    google_load_template_script 'google_load_videos', javascript_callback, uri, content_id do
      %Q{var link = jQuery(item.content).find('img').parent('a');
      link.attr('rel', '#{content_id}');
      link.addClass('feed-video');
      jQuery('#' + content_id).append(link);}
    end
  end
    
  def google_load_images_script(javascript_callback, uri, content_id)
    google_load_template_script 'google_load_images', javascript_callback, uri, content_id do
      %Q{var link = jQuery(item.content).find('img').parent('a');
      link.attr('rel', '#{content_id}');
      link.addClass('feed-photo');
      jQuery('#' + content_id).append(link);}
    end
  end
  
  def google_load_entries_script(javascript_callback, uri, content_id)
    google_load_template_script 'google_load_entries', javascript_callback, uri, content_id do
      %Q{var status_class = 'even';
      if(i%2 > 0) { status_class = 'odd'; }
      jQuery('#' + content_id).append('<div class="hentry ' + status_class + '"><h4 class="title"><a class="entry-link" href="#" target="blank">' + item.title + '</a><span class="entry-close"><a class="entry-link-close" href="#">#{t('muck.raker.close')}</a></span></h4><div class="entry">' + item.content + ' <p><a href="' + item.link + '">#{t('muck.raker.read_more')}</a></p></div></div>');}
    end
  end

  def google_load_bookmarks_script(javascript_callback, uri, content_id)
    google_load_template_script 'google_load_bookmarks', javascript_callback, uri, content_id do
      %Q{var status_class = 'even';
      if(i%2 > 0) { status_class = 'odd'; }
      jQuery('#' + content_id).append('<div class="hentry ' + status_class + '"><h4 class="title"><a class="bookmark-link" href="' + item.link + '" target="_blank">' + item.title + '</a></h4></div>');}
    end
  end
  
  # Generates the template code used by all the calls to google.
  def google_load_template_script(method_name, javascript_callback, uri, content_id)
    included_name = "@#{method_name}_included"
    return '' if instance_variable_get(included_name) rescue false
    instance_variable_set(included_name, true)
    %Q{<script type="text/javascript">
    function #{method_name}(uri, content_id, number_of_items){
      jQuery('#' + content_id).html('');
      var feed = new google.feeds.Feed(uri);
      feed.setNumEntries(number_of_items);
      feed.load(function(result) {
        if (!result.error) {
          jQuery.each(result.feed.entries, function(i,item){
            #{yield}
            #{javascript_callback}('#{uri}', '#{content_id}');
          });
        } 
        if (result.error || result.feed.entries.length <= 0) {
          jQuery('#' + content_id).append('<div class="hentry">#{t('muck.raker.no_entries_found')}</div>');
        }
      });
    }
    </script>}
  end
  
  # Renders a partial with the latest trends from google.
  def google_hot_trends(limit = 10)
    feed = Feed.fetch_feed('http://www.google.com/trends/hottrends/atom/hourly')
    result = Nokogiri::HTML(feed.entries[0].content)
    google_hot_trends_terms = result.css('a').collect{ |a| change_chars(a.text) }.compact
    render :partial => 'google/hot_trends', :locals => { :google_hot_trends_terms => google_hot_trends_terms[0, limit] }
  end
  
  # Outputs include script for google ajax api
  def google_ajax_api_scripts
    return '' if defined?(@google_ajax_api_scripts_included)
    script = '<script type="text/javascript" src="http://www.google.com/jsapi'
    script << "?key=#{GlobalConfig.google_ajax_api_key}" if GlobalConfig.google_ajax_api_key
    script << '"></script>'
    @google_ajax_api_scripts_included = true
    script
  end
  
  # Output include script for google slideshows
  def google_ajax_slideshow_scripts
    return '' if defined?(@google_ajax_slideshow_scripts_included)
    @google_ajax_slideshow_scripts_included = true
    '<script src="http://www.google.com/uds/solutions/slideshow/gfslideshow.js" type="text/javascript"></script>'
  end
  
  # Output include script for google feeds
  def google_load_feeds
    return '' if defined?(@google_load_feeds_included)
    @google_load_feeds_included = true
    google_ajax_api_scripts + '<script type="text/javascript">google.load("feeds", "1");</script>'
  end
  
  # Output include script for google search
  def google_load_search
    return '' if defined?(@google_load_search_included)
    @google_load_search_included = true
    google_ajax_api_scripts + '<script type="text/javascript">google.load("search", "1");</script>'
  end
  
  # Output include script to load jquery from google
  def google_load_jquery
    return '' if defined?(@google_load_jquery_included)
    @google_load_jquery_included = true
    google_ajax_api_scripts + '<script type="text/javascript">google.load("jquery", "1");</script>'
  end

  # Output include script to load jquery ui from google
  def google_load_jquery_ui
    return '' if defined?(@google_load_jquery_ui_included)
    @google_load_jquery_ui_included = true
    google_ajax_api_scripts + '<script type="text/javascript">google.load("jqueryui", "1");</script>'
  end
  
  def change_chars(term)
    term.gsub('+', ' ').gsub('.', '-')
  end
  
end