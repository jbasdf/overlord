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
    
    # userip:      Ip address of user on whose behave a request is made. Helps reduce the chance that google will ban the server.
    def self.user_ip=(val)
      @userip = val
    end

    def self.user_ip
      @userip
    end
    
    # Add standard items to the google query
    def self.build_google_query(query_options)
      key = self.api_key_id || GlobalConfig.google_ajax_api_key rescue ''
      query_options[:v] = '1.0'
      query_options[:key] = key if key
      query_options[:userip] = self.user_ip if self.user_ip
      query_options
    end
    
    # Gets and parses json from a given url
    # uri:      Uri from which to obtain json
    # options:  Options to be sent
    #           :query - query
    #           :headers - headers 
    def self.get(uri, options = {})
      header_params = { "UserAgent" => "Ruby/#{RUBY_VERSION}" }
      ref = self.referer || GlobalConfig.request_referer rescue nil
      header_params["Referer"] = ref if ref
      header_params = header_params.merge(options[:headers]) if options[:headers]
      # to_params comes from the httparty gem
      params = "?#{options[:query].to_params}" if options[:query]
      buffer = open("#{uri}#{params}", header_params).read
      
      # Try the standard parser
      begin
        return JSON.parse(buffer)
      rescue => ex
        puts ex
      end
      
      # Try the crack parser
      begin
        return Crack::JSON.parse(json)
      rescue => ex
        puts ex
      end
      
      {}
    end
    
    def self.parse_name(name)
      return '' if name.blank?
      names = name.split(' ')
      return '' if names.length <= 0
      return [names[0], names[0]] if names.length == 1
      [names[0], names.slice(1, names.length).join(' ')]
    end
    
  end
  
  
end