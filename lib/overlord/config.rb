# Configure overlord
#
module Overlord

  def self.configuration
    # In case the user doesn't setup a configure block we can always return default settings:
    @configuration ||= Configuration.new
  end
  
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :google_ajax_api_key
    attr_accessor :request_referer
    attr_accessor :show_google_search
    attr_accessor :load_feeds_on_server
    attr_accessor :combine_feeds_on_server
    attr_accessor :google_ad_partner_pub
    
    def initialize
      @google_ajax_api_key = nil
      @request_referer = nil
      @google_ad_partner_pub = nil
      @show_google_search = true
      @load_feeds_on_server = false
      @combine_feeds_on_server = false
    end
  end
  
end