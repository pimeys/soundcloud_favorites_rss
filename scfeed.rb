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

get '/rss/:user' do 
  content_type 'application/atom+xml'
  cache_control :public, :must_revalidate, :max_age => 60

  @user = SoundCloud.find_user(params[:user])
  if @user
    # name, bio, summary and url
    @top_list = SoundCloud.favorites(@user["id"]).map do |favorite|
      favorite.merge(LastFM.artist_bio(favorite[:name], favorite[:url]))
    end

    haml(:rss, :format => :xhtml, :escape_html => false, :layout => false)
  else
    return 404
  end
end
