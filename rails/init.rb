ActiveSupport::Dependencies.load_once_paths << lib_path

require 'overlord'

ActionController::Base.send :helper, OverlordGoogleHelper