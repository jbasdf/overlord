module Overlord

  class GoogleBase
  
    # api_key_id:   Valid Google access key (optional)
    def self.api_key_id=(val)
      @api_key_id = val
    end
    
    def self.api_key_id
      @api_key_id
    end
    
    # referer:      Url of the website making request.  Required by Google.
    def self.referer=(val)
      @referer = val
    end

    def self.referer
      @referer
    end
    
    # Add standard items to the google query
    def self.build_google_query(query_options)
      key = self.api_key_id || GlobalConfig.google_ajax_api_key rescue ''
      query_options[:v] = '1.0'
      query_options[:key] = key if key
      query_options
    end
  
    def self.get(uri, options)
      header_params = { "UserAgent" => "Ruby/#{RUBY_VERSION}" }
      ref = self.referer || GlobalConfig.google_ajax_referer rescue nil
      header_params["Referer"] = ref if ref
      # to_params comes from the httparty gem
      buffer = open("#{uri}?#{options[:query].to_params}", header_params).read
      JSON.parse(buffer)
    end
    
  end
  
  
end