# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def path_json_file
    "data/#{File.basename(params[:id])}.json"
  end
end

not_found do
  erb :not_found
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = Dir.glob('data/*').map { |file| JSON.parse(File.open(file).read) }
  @memos = @memos.sort_by { |file| file['time'] }.reverse!
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  hash = { id: SecureRandom.uuid, title: params[:title], content: params[:content], time: Time.now.strftime('%Y/%m/%d %H:%M:%S') }
  File.open("data/#{hash[:id]}.json", 'w') { |file| JSON.dump(hash, file) }
  redirect '/memos'
end

get '/memos/:id' do
  File.exist?(path_json_file) ? (memo = File.open(path_json_file) { |file| JSON.parse(file.read) }) : (redirect to('not_found'))
  @title = memo['title']
  @content = memo['content']
  @id = memo['id']
  erb :show
end

get '/memos/:id/edit' do
  memo = File.open(path_json_file) { |file| JSON.parse(file.read) }
  @title = memo['title']
  @content = memo['content']
  @id = memo['id']
  erb :edit
end

patch '/memos/:id' do
  File.open(path_json_file, 'w') do |file|
    hash = { id: params[:id], title: params[:title], content: params[:content], time: Time.now.strftime('%Y/%m/%d %H:%M:%S') }
    JSON.dump(hash, file)
  end
  redirect '/memos'
end

delete '/memos/:id' do
  File.delete(path_json_file)
  redirect '/memos'
end
