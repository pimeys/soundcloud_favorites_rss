require 'sinatra'
require 'net/http'
require 'json'
require 'builder'
require File.expand_path(File.dirname(__FILE__) + '/config/settings')

get '/' do
  File.read(File.join('public', 'index.html'))
end

get '/rss/:user' do	
  favorites = get_favorites_with_username(params[:user])
  @favorites_top_list = get_favorite_artists_sorted(favorites)

  builder :rss
end

get '/error' do
  "User not found :P"
end

private

def get_favorites_with_username(username)
  resp = Net::HTTP.get(URI.parse("http://api.soundcloud.com/users.json?client_id=#{settings.soundcloud_key}&q=#{username}&limit=1"))
  users = JSON.parse(resp)
  return nil if users.empty?
  user = users.first
  JSON.parse(Net::HTTP.get(URI.parse("http://api.soundcloud.com/users/#{user['id']}/favorites.json?client_id=#{settings.soundcloud_key}")))
end

def get_favorite_artists_sorted(favorites)
  favorites_hash = favorites.reduce({}) do |acc, favorite|
    user_name = favorite["user"]["username"]
    if acc[user_name]
      acc[user_name][:count] += 1
    else
      acc[user_name] = {:count => 1, :link => favorite["user"]["permalink"]}
    end
    acc
  end

  favorites_hash.to_a.sort_by{|favorite| -favorite[1][:count]}
end
