require 'net/http'
require File.expand_path(File.dirname(__FILE__) + '/../config/settings')

class SoundCloud
	BASE_URL = "http://api.soundcloud.com"

	def self.find_user(query)
		url = URI.parse("#{BASE_URL}/users.json?client_id=#{settings.soundcloud_key}&q=#{query}&limit=1")
		users = JSON.parse(Net::HTTP.get(url))
		if users.empty?
			return nil
		else
			return users.first
		end
	end

	def self.favorites(user_id)
		url = URI.parse("#{BASE_URL}/users/#{user_id}/favorites.json?client_id=#{settings.soundcloud_key}")
		resp = JSON.parse(Net::HTTP.get(url))

		favorites = resp.reduce({}) do |acc, favorite|
			artist = favorite["user"]["username"]
			if acc[artist]
				acc[artist][:count] += 1
			else
				acc[artist] = {:count => 1, :link => favorite["user"]["permalink"]}
			end

			acc
		end
		
		return favorites.to_a.sort_by{|favorite| -favorite[1][:count]}
	end
end
