require 'net/http'
require 'cgi'
require File.expand_path(File.dirname(__FILE__) + '/../config/settings')

class LastFM
	BASE_URL = "http://ws.audioscrobbler.com/2.0"

	def self.artist_bio(artist)
		url = URI.parse("#{BASE_URL}/?format=json&method=artist.getinfo&artist=#{CGI::escape(artist)}&api_key=#{settings.lastfm_key}")
		artist_data = JSON.parse(Net::HTTP.get(url))
		if artist_data["artist"]
			{
				:bio => artist_data["artist"]["bio"]["content"].gsub(/\n/, '<br />'), 
				:summary => artist_data["artist"]["bio"]["summary"],
				:url => artist_data["artist"]["url"]
			}
		else
			{:bio => "", :summary => ""}
		end
	end
end
