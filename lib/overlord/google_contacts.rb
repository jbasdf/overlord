module Overlord
    
  class GoogleContacts < GoogleBase
  
    # GET http://www.google.com/m8/feeds/contacts/default/base
    # OAuth::Consumer
    # limit
    def self.contacts(oauth_consumer, limit = 10000)
      convert_google_contacts_json_to_users(load_contacts(oauth_consumer, limit))
    end
  
    def self.load_contacts(token, limit = 10000)
      #http://www.google.com/m8/feeds/contacts/default/full
      #http://www.google.com/m8/feeds/contacts/default/base
      get('http://www.google.com/m8/feeds/contacts/default/full',
            :query => { 'max-results' => limit },
            :headers => authorization_header(token) )
    end
    
    # Converts json returned from google into a feed object
    def self.convert_google_contacts_json_to_users(json)
      if json['responseStatus'] == 200
        if json['responseData']['feed']['entries']
          json['responseData']['feed']['entries'].collect do |entry|
            first_name, last_name = parse_name(entry['gd:name'])
            OpenStruct.new( { :email => entry['gd:email'],
                              :first_name => first_name,
                              :last_name => last_name } )
          end
        end
      end
    end
    
    #
    # Overlord::GoogleContacts.validate_token(user.google.token)
    def self.validate_token(token)
      get('https://www.google.com/accounts/AuthSubTokenInfo', authorization_header(token))
    end
  
    #Authorization: AuthSub token="yourSessionToken"
    # Overlord::GoogleContacts.authorization_header(user.google.token)
    # Authorization: OAuth
    # oauth_token="1%2Fab3cd9j4ks73hf7g",
    # oauth_signature_method="RSA-SHA1",
    # oauth_signature="wOJIO9A2W5mFwDgiDvZbTSMK%2FPY%3D",
    # oauth_consumer_key="example.com",
    # oauth_timestamp="137131200",
    # oauth_nonce="4572616e48616d6d65724c61686176",
    # oauth_version="1.0"
    
    # Authorization: OAuth oauth_token="1%2Fab3cd9j4ks73hf7g", oauth_signature_method="RSA-SHA1", oauth_signature="wOJIO9AvZbTSMK%2FPY%3D...", 
    # oauth_consumer_key="example.com", oauth_timestamp="137131200", oauth_nonce="4572616e48616d6d", oauth_version="1.0"
    
    # base_string = http-method&base-http-request-url&normalized-string-of-oauth_parameters
    #  
    #  GET&http%3A%2F%2Fwww.google.com%2Fcalendar%2Ffeeds%2Fdefault%2Fallcalendars%2Ffull&oauth_consumer_key%3Dexample.com%26oauth_nonce%3D4572616e48616d6d%26oauth_signature_method%3DRSA-SHA1%26oauth_timestamp%3D137131200%26oauth_token%3D1%252Fab3cd9j4ks73hf7g%26oauth_version%3D1.0%26orderby%3Dstarttime
     
    
    #   @consumer.request(:get,  '/people', @token, { :scheme => :query_string })
    #   @consumer.request(:post, '/people', @token, {}, @person.to_xml, { 'Content-Type' => 'application/xml' })
    #
    #def request(http_method, path, token = nil, request_options = {}, *arguments)
      
    def self.authorization_header(token)
      { "Authorization" => %Q{OAuth oauth_token="#{token}", oauth_consumer_key=#{GlobalConfig.google_oauth_key}, oauth_version="1.0"} }
    end

  end

end