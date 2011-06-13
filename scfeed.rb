require 'sinatra'
require 'net/http'
require 'json'
require 'builder'
require File.expand_path(File.dirname(__FILE__) + '/config/settings')

get '/' do
	File.read(File.join('public', 'index.html'))
end

get '/rss/:user' do	

	resp = Net::HTTP.get(URI.parse("http://api.soundcloud.com/users.json?client_id=#{settings.soundcloud_key}&q=#{params[:user]}&limit=1"))
	users = JSON.parse(resp)
	redirect to('/error'), 404 and return if users.empty?
	user = users.first
	favorites = JSON.parse(Net::HTTP.get(URI.parse("http://api.soundcloud.com/users/#{user['id']}/favorites.json?client_id=#{settings.soundcloud_key}")))

	@favorites_top_list = favorites.reduce({}) do |acc, favorite|
		user_name = favorite["user"]["username"]
		if acc[user_name]
			acc[user_name] += 1
		else
			acc[user_name] = 1
		end
		acc
	end

	builder :rss
end

get '/error' do
	"User not found :P"
end

private

def load_config file
	yaml = YAML.load_file
end
