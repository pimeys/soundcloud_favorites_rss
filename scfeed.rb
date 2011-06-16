require 'sinatra'
require 'json'
require 'builder'
require File.expand_path(File.dirname(__FILE__) + '/lib/soundcloud')
require File.expand_path(File.dirname(__FILE__) + '/lib/lastfm')

get '/' do
  File.read(File.join('public', 'index.html'))
end

get '/rss/:user' do	
	user = SoundCloud.find_user(params[:user])
	if user
		@favorites_top_list = SoundCloud.favorites(user["id"])
		@favorites_top_list.each do |favorite|
			favorite[1].merge!({:bio => LastFM.artist_bio(favorite[0])})
		end

		builder :rss
	else
		return 404
	end
end
