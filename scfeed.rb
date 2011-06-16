require 'sinatra'
require 'json'
require 'builder'
require 'rack/cache'
require 'haml'
require 'date'
require File.expand_path(File.dirname(__FILE__) + '/lib/soundcloud')
require File.expand_path(File.dirname(__FILE__) + '/lib/lastfm')

use Rack::Cache, {
	:metastore   => 'heap:/',
	:entitystore => 'heap:/'
}

get '/' do
  File.read(File.join('public', 'index.html'))
end

get '/rss/:user' do	
	content_type 'application/rss+xml'
	cache_control :public, :must_revalidate, :max_age => 60

	@user = SoundCloud.find_user(params[:user])
	if @user
		@favorites_top_list = SoundCloud.favorites(@user["id"])
		@favorites_top_list.each do |favorite|
			favorite[1].merge!(LastFM.artist_bio(favorite[0]))
		end

		haml(:rss, :format => :xhtml, :escape_html => false, :layout => false)
	else
		return 404
	end
end
