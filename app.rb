require 'sinatra'
require 'sqlite3'
require 'sequel'

DB = Sequel.sqlite('blog.db')

get '/' do
  @posts = DB[:posts]
  @comments = DB[:comments]
  erb :posts
end

get '/posts/new' do
  erb :new_post
end

post '/posts' do
  DB[:posts].insert(
    id: params[:id],
    title: params[:title],
    content: params[:content],
    author: params[:author]
  )
  redirect '/'
end

get '/posts/:id' do
  @post = DB[:posts][:id => params['id']]
  @post_comments = DB[:comments].where(:post_id => params['id'])
  erb :post
end

get '/posts/:id/edit' do
  @post = DB[:posts][:id => params['id']]
  erb :post_edit
end

put '/posts/:id' do
  puts params.inspect
  DB[:posts].where(:id => params['id']).update(:title => params['title'], :author => params['author'], :content => params['content'])
  redirect "/posts/#{params['id']}"
end

post '/posts/:id/new-comment' do
  DB[:comments].insert(
    post_id: params[:post_id],
    comment_id: params[:comment_id],
    comment_content: params[:comment_content],
    comment_author: params[:comment_author]
  )
  redirect "/posts/#{params['id']}"
end

get '/admin' do
  @posts = DB[:posts]
  @comments = DB[:comments]
  erb :admin
end

post '/admin/delete_comment' do
  DB[:comments].where(
    comment_id: params[:delete_comment]
  ).delete
  #binding.pry
  redirect '/admin'
end

post '/admin/delete_post' do
  DB[:posts].where(
    id: params[:delete_post]
  ).delete
  #binding.pry
  redirect '/admin'
end

#Get/posts/ for displaying all the posts on homepage; list of titles and maybe excerpt of content
#GET/posts/1 show post 1 - title, author, content
#GET/posts/1/edit to open up the editable form, then what goes out is PUT/posts/1

#If you want not to lose the comments, but just not show them, you can just 'mark them as deleted' but not actually delete them
#with a boolean column added to each post / column
