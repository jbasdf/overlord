# tag_list can be from one of the various acts_as_taggable gems.
class Entry < ActiveRecord::Base
  belongs_to :feed
  attr_accessor :tag_list
end