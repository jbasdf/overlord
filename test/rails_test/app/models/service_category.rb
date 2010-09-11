# == Schema Information
#
# Table name: service_categories
#
#  id   :integer(4)      not null, primary key
#  name :string(255)     not null
#  sort :integer(4)      default(0)
#

class ServiceCategory < ActiveRecord::Base
  has_many :services, :order => 'sort ASC'
end
