module Overlord
  module JsonParser
  
    # The various json parsers can choke on various json so try them all
    def parse_json(data)
      try_crack(data) || try_json(data) || try_active_json(data)
    end
  
    def try_crack(data)
      Crack::JSON.parse(data)
    rescue => ex
      #puts ex
      nil
    end
  
    def try_json(data)
     JSON.parse(data)
    rescue => ex
      #puts ex
      nil
    end
  
    def try_active_json(data)
      ActiveSupport::JSON.decode(data)
    rescue => ex
      #puts ex
      nil
    end
  
  end
end