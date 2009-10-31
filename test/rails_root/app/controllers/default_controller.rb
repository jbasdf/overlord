class DefaultController < ApplicationController
  
  before_filter :setup
  
  def index
  end
  
  def google_search
  end
  
  def google_feeds
  end
  
  def google_combined_feeds
  end
  
  def google_dynamic_feeds_vertical
  end
  
  def google_feed_search
  end
  
  def google_slide_show
  end
    
  def setup
    @terms = CGI.unescape('mountain biking')

    @number_of_items = 6
    @number_of_images = 12
    @number_of_videos = 6
    @show_controls = false
    @feeds = Feed.all
  end
  
end