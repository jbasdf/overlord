require File.dirname(__FILE__) + '/../test_helper'

class DefaultControllerTest < ActionController::TestCase

  tests DefaultController

  context "topics controller" do

    setup do
      @feed = Factory(:feed, :uri => TEST_RSS_URI, :display_uri => TEST_URI)
    end
    
    context "GET google_search" do
      setup do
        get :google_search
      end
      should_not set_the_flash
      should respond_with :success
      should render_template :google_search
    end
    
    context "GET google_feeds" do
      setup do
        get :google_feeds
      end
      should_not set_the_flash
      should respond_with :success
      should render_template :google_feeds
    end
    
    context "GET google_combined_feeds" do
      setup do
        get :google_combined_feeds
      end
      should_not set_the_flash
      should respond_with :success
      should render_template :google_combined_feeds
    end
    
    context "GET google_dynamic_feeds_vertical" do
      setup do
        get :google_dynamic_feeds_vertical
      end
      should_not set_the_flash
      should respond_with :success
      should render_template :google_dynamic_feeds_vertical
    end
    
    context "GET google_feed_search" do
      setup do
        get :google_feed_search
      end
      should_not set_the_flash
      should respond_with :success
      should render_template :google_feed_search
    end
    
    context "GET google_slide_show" do
      setup do
        get :google_slide_show
      end
      should_not set_the_flash
      should respond_with :success
      should render_template :google_slide_show
    end
    
  end
  
end