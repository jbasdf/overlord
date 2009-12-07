module Overlord
  # Google ajax search api reference:
  # http://code.google.com/apis/ajaxsearch/documentation
  #
  # Google code playground:
  # http://code.google.com/apis/ajax/playground
  #
  class GoogleSearchRequest < GoogleBase
  
    # Run a local search
    # Google docs:
    # http://code.google.com/apis/ajaxsearch/documentation/reference.html#_fonje_local
    # For example:
    # rsz     This optional argument supplies the number of results that the application would like to recieve. A value of small 
    #         indicates a small result set size or 4 results. A value of large indicates a large result set or 8 results. 
    #         If this argument is not supplied, a value of small is assumed.
    # start   This optional argument supplies the start index of the first search result. Each successful response contains 
    #         a cursor object (see below) which includes an array of pages. The start property for a page may be used as a 
    #         valid value for this argument.
    #
    # Pass any of the standard search options:
    #  http://code.google.com/apis/ajaxsearch/documentation/reference.html#_intro_fonje
    #
    # Pass any of the following options:
    # sll     This optional argument supplies the search center point for a local search. It's value is a comma separated latitude/longitude pair, e.g., sll=48.8565,2.3509.
    # sspn    This optional argument supplies a bounding box that the local search should be relative to. When using a Google Map, the sspn value can be computed using: myMap.getBounds().toSpan().toUrlValue(); (e.g., sspn=0.065169,0.194149).
    # mrt     This optional argument specifies which type of listing the user is interested in. Valid values include:
    #    * blended - request KML, Local Business Listings, and Geocode results
    #    * kmlonly - request KML and Geocode results
    #    * localonly - request Local Business Listings and Geocode results
    #     If this argument is not supplied, the default value of localonly is used.
    # 
    def self.local_search(query, options = {})
      get('http://ajax.googleapis.com/ajax/services/search/local', :query => build_google_query(options.merge(:q => query)))
    end

    # Converts json returned from google into a feed object
    # Each object has the following attributes.  For more details on each attribute see http://code.google.com/apis/ajaxsearch/documentation/reference.html#_intro_fonje
    # viewportmode      "computed"
    # country           "United States"
    # streetAddress     "300 Grove St"
    # region            "CA"
    # titleNoFormatting "Jardiniere Restaurant"
    # ddUrlFromHere     "http://www.google.com/maps?source=uds&saddr=300+Grove+St%2C+San+Francisco%2C+CA+%28Jardiniere+Restaurant%29+%4037.778127%2C-122.421735&iwstate1=dir%3Afrom"
    # content           ""
    # ddUrlToHere       "http://www.google.com/maps?source=uds&daddr=300+Grove+St%2C+San+Francisco%2C+CA+%28Jardiniere+Restaurant%29+%4037.778127%2C-122.421735&iwstate1=dir%3Ato"
    # url               "http://www.google.com/local?source=uds&q=food&sll=37.778127%2C-122.421735&latlng=37778127%2C-122421735%2C16134753875200198327&near=37.778127%2C-122.421735"
    # city              "San Francisco"
    # accuracy          "8"
    # phoneNumbers      [{"number"=>"(415) 861-5555", "type"=>""}, {"number"=>"(415) 555-1212", "type"=>""}]
    # listingType       "local"
    # maxAge            604800
    # title             "Jardiniere Restaurant"
    # ddUrl             "http://www.google.com/maps?source=uds&daddr=300+Grove+St%2C+San+Francisco%2C+CA+%28Jardiniere+Restaurant%29+%4037.778127%2C-122.421735&saddr"
    # staticMapUrl      "http://mt.google.com/mapdata?cc=us&tstyp=5&Point=b&Point.latitude_e6=37778127&Point.longitude_e6=-122421735&Point.iconid=15&Point=e&w=150&h=100&zl=4"
    # GsearchResultClass  "GlocalSearch"
    # lat               "37.778127"
    # addressLines      ["300 Grove St", "San Francisco, CA"]
    # lng               "-122.421735"
    def self.convert_google_search_json_to_objects(json)
      if json['responseStatus'] == 200
        if json['responseData']['results']
          json['responseData']['results'].collect{ |result| OpenStruct.new(result) }
        end
      end
    end
  
  end
end