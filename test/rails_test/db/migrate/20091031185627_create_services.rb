class CreateServices < ActiveRecord::Migration
  def self.up
    create_table "services", :force => true do |t|
      t.string  "uri",                 :limit => 2083, :default => ""
      t.string  "name",                :limit => 1000, :default => ""
      t.string  "api_uri",             :limit => 2083, :default => ""
      t.string  "uri_key"
    end
  end

  def self.down
    drop_table "services"
  end
end
