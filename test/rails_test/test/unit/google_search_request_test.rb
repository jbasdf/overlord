require File.dirname(__FILE__) + '/../test_helper'

class GoogleSearchRequestTest < ActiveSupport::TestCase 
  
  context "google search requests" do
    setup do
    end
    
    context "local search" do
      setup do
        @results = Overlord::GoogleSearchRequest.local_search('food')
      end
      should "get local search results" do
        assert @results.length > 0
        assert_equal 200, @results['responseStatus']
      end
      should "convert google json into objects" do
        @objects = Overlord::GoogleSearchRequest.convert_google_search_json_to_objects(@results)
        assert @objects.length > 0
        assert @objects[0].country
      end
    end

  end
  
end