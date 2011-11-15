require 'rubygems'
require 'sinatra'

set :public_folder, Proc.new { File.join(root, "_site") }

# Added headers for Varnish
before do
  response.headers['Cache-Control'] = 'public, max-age=31557600'
end

# Handle old site URLs with a permanent redirect
get "/index.php/*" do |title|
  redirect title, 301
end

get '/' do
  File.read("_site/index.html")
end

get "/*" do |title|
  puts title
  File.read("_site/#{title}/index.html")
end
