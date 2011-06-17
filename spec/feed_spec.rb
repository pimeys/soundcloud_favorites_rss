require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Soundcloud Favorites" do
  it "should respond to /" do
    get '/'
    last_response.should be_ok
  end

  it "should generate a RSS feed for user 'pimeys'" do
    get '/rss/pimeys'
    last_response.should be_ok
    last_response["Content-Type"].should eql("application/rss+xml")
  end
end
