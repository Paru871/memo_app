# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require_relative 'memo_class'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

memo = Memo.new

not_found do
  erb :not_found
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = memo.read_all_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  memo.create(params[:title], params[:content])
  redirect '/memos'
end

get '/memos/:id' do
  @memo = memo.read_memo(params[:id])
  @memo ? (erb :show) : (redirect to('not_found'))
end

get '/memos/:id/edit' do
  @memo = memo.read_memo(params[:id])
  @memo ? (erb :edit) : (redirect to('not_found'))
end

patch '/memos/:id' do
  @memo = memo.read_memo(params[:id])
  @memo ? memo.update(params[:title], params[:content], params[:id]) : (redirect to('not_found'))
  redirect '/memos'
end

delete '/memos/:id' do
  @memo = memo.read_memo(params[:id])
  @memo ? memo.delete(params[:id]) : (redirect to('not_found'))
  redirect '/memos'
end
