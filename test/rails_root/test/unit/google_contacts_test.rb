require File.dirname(__FILE__) + '/../test_helper'

class GoogleContactsTest < ActiveSupport::TestCase 
  
  context "google contacts requests" do
    setup do
    end
    
    context "local search" do
      setup do
        @json = ''
      end
      should "convert google json into objects" do
        @objects = Overlord::GoogleContacts.convert_google_contacts_json_to_users(@json)
        assert @objects.length > 0
        assert @objects[0].country
      end
    end

  end
  
end