require 'overlord'
require 'rails'

module Overlord
  class Engine < ::Rails::Engine
      
    initializer 'overlord.helper' do |app|
      ActiveSupport.on_load(:action_view) do
        include OverlordGoogleHelper
      end
    end
    
  end
end
