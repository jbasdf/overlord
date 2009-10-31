$:.reject! { |e| e.include? 'TextMate' }
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'ruby-debug'
gem 'thoughtbot-factory_girl' # from github
require 'factory_girl'
require 'mocha'
require 'active_record/fixtures'
require 'redgreen' rescue LoadError
require File.expand_path(File.dirname(__FILE__) + '/factories')
require File.join(File.dirname(__FILE__), 'shoulda_macros', 'controller')
require File.join(File.dirname(__FILE__), 'shoulda_macros', 'models')

class ActiveSupport::TestCase 
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = true
  
  TEST_URI = 'http://www.engadget.com'
  TEST_RSS_URI = 'http://www.engadget.com/rss.xml'
  
  def ensure_flash(val)
    assert_contains flash.values, val, ", Flash: #{flash.inspect}"
  end
  
  def ensure_flash_contains(val)
    flash.values.each do |flv|
      return true if flv.include?(val)
    end
    false
  end
  
end
