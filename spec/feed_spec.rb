require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Soundcloud Favorites" do
  it "should respond to /" do
    get '/'
    last_response.should be_ok
  end
end
