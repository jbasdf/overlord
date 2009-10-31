class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table "feeds", :force => true do |t|
      t.string   "uri",                        :limit => 2083
      t.string   "display_uri",                :limit => 2083
      t.string   "title",                      :limit => 1000
      t.integer  "service_id",                                 :default => 0
      t.string   "login"
    end
  end

  def self.down
    drop_table "feeds"
  end
end
