require File.dirname(__FILE__) + '/../test_helper'

class DefaultControllerTest < ActionController::TestCase

  tests DefaultController

  context "topics controller" do

    context "GET google_search" do
      setup do
        get :google_search
      end
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :google_search
    end
    
  end
  
end