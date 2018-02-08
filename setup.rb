require 'sqlite3'
require 'sequel'

DB = Sequel.sqlite('blog.db')

# create an items table
DB.create_table! :posts do
  primary_key :id
  String :title
  String :content
  String :author
end

DB.create_table! :comments do
  primary_key :comment_id
  String :post_id
  String :comment_author
  String :comment_content
end
