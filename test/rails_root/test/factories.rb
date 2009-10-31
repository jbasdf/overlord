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
