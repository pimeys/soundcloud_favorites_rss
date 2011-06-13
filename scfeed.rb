require 'sinatra'

get '/' do
	File.read(File.join('public', 'index.html'))
end

post '/' do
end

get '/:id' do
end
