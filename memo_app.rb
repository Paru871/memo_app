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
  hash = { id: SecureRandom.uuid, title: params[:title], content: params[:content], time: Time.now.iso8601 }
  File.open("data/#{hash[:id]}.json", 'w') { |file| JSON.dump(hash, file) }
  redirect '/memos'
end

get '/memos/:id' do
  File.exist?(path_json_file) ? (@memo = File.open(path_json_file) { |file| JSON.parse(file.read) }) : (redirect to('not_found'))
  erb :show
end

get '/memos/:id/edit' do
  File.exist?(path_json_file) ? (@memo = File.open(path_json_file) { |file| JSON.parse(file.read) }) : (redirect to('not_found'))
  erb :edit
end

patch '/memos/:id' do
  if File.exist?(path_json_file)
    File.open(path_json_file, 'w') do |file|
      hash = { id: params[:id], title: params[:title], content: params[:content], time: Time.now.iso8601 }
      JSON.dump(hash, file)
    end
  else
    redirect to('not_found')
  end
  redirect '/memos'
end

delete '/memos/:id' do
  File.exist?(path_json_file) ? File.delete(path_json_file) : (redirect to('not_found'))
  redirect '/memos'
end
