Factory.sequence :email do |n|
  "somebody#{n}@example.com"
end

Factory.sequence :uri do |n|
  "www#{n}.example.com"
end

Factory.sequence :login do |n|
  "inquire#{n}"
end

Factory.sequence :name do |n|
  "a_name#{n}"
end

Factory.sequence :abbr do |n|
  "abbr#{n}"
end

Factory.sequence :locale do |n|
  "a#{n}"
end

Factory.sequence :description do |n|
  "This is the description: #{n}"
end

Factory.sequence :title do |n|
  "This is the title: #{n}"
end

Factory.define :feed do |f|
  f.uri { Factory.next(:uri) }
  f.display_uri { Factory.next(:uri) }
  f.title { Factory.next(:title) }
end

Factory.define :entry do |f|
  f.feed { |a| a.association(:feed) }
  f.permalink { Factory.next(:uri) }
  f.author { Factory.next(:name) }
  f.title { Factory.next(:title) }
  f.description { Factory.next(:description) }
  f.content { Factory.next(:description) }
  f.unique_content { Factory.next(:description) }
  f.published_at DateTime.now
  f.language { |a| a.association(:language) }
  f.direct_link { Factory.next(:uri) }
  f.grain_size 'unknown'
end

Factory.define :service do |f|
  f.uri { Factory.next(:uri) }
  f.name { Factory.next(:name) }
  f.service_category { |a| a.association(:service_category) }
end