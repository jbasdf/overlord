class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table "entries", :force => true do |t|
      t.integer  "feed_id",                                                                    :null => false
      t.string   "permalink",               :limit => 2083, :default => "",                    :null => false
      t.string   "author",                  :limit => 2083
      t.text     "title",                                                                      :null => false
      t.text     "description"
      t.text     "content"
      t.datetime "published_at",                                                               :null => false
      t.string   "direct_link",             :limit => 2083
     end
  end

  def self.down
    drop_table "entries"
  end
end
