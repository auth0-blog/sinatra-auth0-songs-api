# frozen_string_literal: true

require 'sinatra'
require 'json'
require_relative 'helpers/songs_helper'

songs ||= SongsHelper.songs

set :method do |*methods|
  methods = methods.map { |m| m.to_s.upcase }
  condition { methods.include?(request.request_method) }
end

helpers do
  def json_params
    request.body.rewind
    @json_params ||= JSON.parse(request.body.read).transform_keys(&:to_sym)
  rescue JSON::ParserError
    halt 400, { message: 'Invalid JSON body' }.to_json
  end

  def require_params!
    json_params

    attrs = %i[name url]

    halt(400, { message: 'Missing parameters' }.to_json) if (attrs & @json_params.keys).empty?
  end

  def id_param
    halt 400, { message: 'Bad Request' }.to_json if params['id'].to_i < 1
    params['id'].to_i
  end
end

before do
  content_type 'application/json'
end

before method: %i[post put] do
  require_params!
end

get '/songs' do
  return songs.to_json
end

get '/songs/:id' do
  song = songs.find { |s| s.id == id_param }
  halt 404, { message: 'Song Not Found' }.to_json unless song

  return song.to_json
end

post '/songs' do
  create_params = @json_params.slice(:name, :url)

  if create_params.keys.sort == %i[name url]
    new_song = { id: songs.size + 1, name: @json_params[:name], url: @json_params[:url] }
  else
    halt(400, { message: 'Missing parameters' }.to_json)
  end

  songs.push(new_song)

  return new_song.to_json
end

put '/songs/:id' do
  song = songs.find { |s| s.id == id_param }

  halt 404, { message: 'Song Not Found' }.to_json unless song

  song.name = @json_params[:name] if @json_params.keys.include? :name
  song.url = @json_params[:url] if @json_params.keys.include? :url

  return song.to_json
end

delete '/songs/:id' do
  song = songs.find { |s| s.id == id_param }
  halt 404, { message: 'Song Not Found' }.to_json unless song

  song = songs.delete(song)

  return song.to_json
end
