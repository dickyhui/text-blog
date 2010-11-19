require 'rspec'
require 'app'
require 'nokogiri'

describe "blog" do
  before do
    @req = Rack::MockRequest.new(Sinatra::Application)
  end
  it "should show index correctly" do
    resp = @req.get '/'
    resp.status.should == 200
    doc = Nokogiri(resp.body)
    (doc/'a[href="/2010/10/10/a-lucky-day"]').text.should == "A Lucky Day"
  end
  it "should show article correctly" do
    resp = @req.get '/2010/10/10/a-lucky-day'
    resp.status.should == 200
    doc = Nokogiri(resp.body)
    (doc/'title').text.should == "A Lucky Day"
    (doc/'article h1').text.should == "今天是我的幸运日"
    resp.body.should match "钱包里面正好有42块钱"
  end

  it "should halt 404 for nonexisting blog" do
    resp = @req.get "/2010/10/10/not-lucky-day"
    resp.status.should == 404
  end
end
