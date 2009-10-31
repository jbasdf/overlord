require 'test_helper'

class GoogleFeedRequestTest < ActiveSupport::TestCase 
  
  context "google feed requests" do

    context "find feeds" do
      setup do
        @feeds = Overlord::GoogleFeedRequest.find_feeds('ruby')
      end
      should "get feeds related to ruby" do
        assert @feeds.length > 0
      end
      should "build objects of type 'Feed'" do
        assert @feeds[0].is_a?(Feed)
      end
    end
  
    context "find feeds (raw results)" do
      setup do
        @feeds = Overlord::GoogleFeedRequest.find_google_feeds('ruby')
      end
      should "get feeds related to ruby" do
        assert @feeds.length > 0
      end
    end
  
    context "lookup feed" do
      setup do
        @result = Overlord::GoogleFeedRequest.lookup_feed('http://www.justinball.com')
      end
      should "discover rss feed using uri" do
        assert_equal 'http://www.justinball.com/feed/', @result['responseData']['url']
      end
    end
    
    context "load feed" do
      setup do
        @entries = Overlord::GoogleFeedRequest.load_feed('http://www.justinball.com')
      end
      should "get entries from feed" do
        assert @entries.length > 0
      end      
    end
    
    context "load an array of feeds" do
      setup do
        @feeds = [ Factory(:feed, :uri => 'http://www.justinball.com/feed'), Factory(:feed, :uri => 'http://www.engadget.com/rss.xml'), Factory(:feed, :uri => 'http://www.example.com') ]
      end
      should "load feeds" do
        @feeds = Overlord::GoogleFeedRequest.load_feeds(@feeds)
        assert @feeds.entries.length > 0
      end
    end
  end
  
end