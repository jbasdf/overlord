require 'json'
require 'open-uri'
require 'overlord/google_base'
require 'overlord/google_search_request'
require 'overlord/google_feed_request'

I18n.load_path += Dir[ File.join(File.dirname(__FILE__), '..', 'locales', '*.{rb,yml}') ]
