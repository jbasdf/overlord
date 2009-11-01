class Service < ActiveRecord::Base
  
  belongs_to :service_category
  
  def photo?
    false
  end
  
  def video?
    false
  end
  
  def bookmark?
    false
  end
  
  def music?
    false
  end
  
  def news?
    false
  end
  
  def blog?
    false
  end
  
  def search?
    false
  end
  
  def general?
    true
  end
  
  # Selects and caches all services from the database.
  # 
  # refresh_services:     By default all tag services are cached.  Setting this value to true
  #                       will result in the values being repopulated from the database
  def self.get_services(refresh_services = false)
    @all_services = nil if refresh_services
    @all_services ||= Service.all
  end
  
  # Attempts to find a service object using a uri
  #
  # uri:              Uri to search for.  This method will attempt to all services for any part of the provided uri.
  # refresh_services: Forces a refresh of the services.  By default the services are cached for the duration of the request.
  def self.find_service_by_uri(uri, refresh_services = false)
    service = get_services(refresh_services).detect { |service| service.uri && service.uri.length > 0 && (uri.include?(service.uri) || service.uri.include?(uri)) }
    service ||= default_service
    service
  end
  
  # Default service is RSS
  def self.default_service
    Service.find_by_name('rss') # this will return the default rss service
  end
  
end