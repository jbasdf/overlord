module Overlord
    
  class GoogleContacts < GoogleBase
  
    # GET http://www.google.com/m8/feeds/contacts/default/base
    # oauth_token
    # limit
    def self.contacts(oauth_token, limit = 10000)
      convert_google_contacts_json_to_users(load_contacts(oauth_token, limit))
    end
  
    def self.load_contacts(oauth_token, limit = 10000)
      get('http://www.google.com/m8/feeds/contacts/default/base', 
            :query => { 'max-results' => limit },
            :headers => {'Authorization' => "AuthSubtoken="#{oauth_token}""} )
      end
    end
    
    # Converts json returned from google into a feed object
    def self.convert_google_contacts_json_to_users(json)
      if json['responseStatus'] == 200
        if json['responseData']['feed']['entries']
          json['responseData']['feed']['entries'].collect do |entry|
            first_name, last_name = parse_name(entry['gd:name'])
            OpenStruct.new( { :email => entry, 
                              :first_name => first_name,
                              :last_name => last_name })
          end
        end
      end
    end
    
  end
  
end