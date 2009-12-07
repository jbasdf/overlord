module Overlord

  class GoogleBase
    
    attr_accessor :api_key_id, :referer
    # include HTTParty
    # format :json
  
    # Initialize Google Request.
    # Parameters:
    # api_key_id:   Valid Google access key (optional)
    # referer:      Url of the website making request.  Required by Google.
    # def initialize(api_key_id = nil, referer = '')
    #   @referer = referer
    #   @api_key_id = api_key_id
    # end
    # 
    # def api_key_id
    # end
    # 
    # def referer
    # end
    
    # Add standard items to the google query
    def self.build_google_query(query_options)
      key = self.api_key_id || GlobalConfig.google_ajax_api_key rescue ''
      query_options[:v] = '1.0'
      query_options[:key] = key if key
      query_options
    end
  
    def self.get(uri, options)
      debugger
      buffer = open("#{uri}?#{options.to_params}", "UserAgent" => "Ruby/#{RUBY_VERSION}", "Referer" => self.referer || GlobalConfig.google_ajax_referer).read
      JSON.parse(buffer)
    end
    
  end
  
  
end