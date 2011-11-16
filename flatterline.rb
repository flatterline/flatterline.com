## Required libraries ##
  require 'rubygems'
  require 'sinatra'

## Global Settings ##
  set :public_folder,  Proc.new { File.join(root, "_site") }
  set :email_username, ENV['SENDGRID_USERNAME']
  set :email_password, ENV['SENDGRID_PASSWORD']
  set :email_address,  'Flatterline Contact Form <notices@flatterline.com>'
  set :email_service,  ENV['SENDGRID_ADDRESS']
  set :email_domain,   ENV['SENDGRID_DOMAIN']

## Before callback ##
  # Added headers for Varnish
  before do
    response.headers['Cache-Control'] = 'public, max-age=31557600' if ENV['RACK_ENV'] == 'production'
  end

## GET requests ##
  # Handle old site URLs with a permanent redirect
  get "/index.php/*" do |title|
    redirect title, 301
  end

  # Index page
  get '/' do
    File.read("_site/index.html")
  end

  # Other static pages
  [:contact].each do |page|
    get "/#{page}/?" do
      File.read("_site/#{page}.html")
    end
  end

  # Dynamic contact form
  get '/contact-form/?' do
    @errors = {}
    erb :contact_form
  end

  get "/*/?" do |title|
    File.read("_site/#{title}/index.html")
  end

## POST requests ##
  # Dynamic contact form
  post '/contact-form/?' do
    if (@errors = validate(params)).empty?
      begin
        send_email params
        @sent = true

      rescue => e
        puts e
        @failure = "Ooops, it looks like something went wrong while attempting to contact us. Mind trying again now or later? :)"
      end
    end

    erb :contact_form
  end

## Helper Methods ##
  def send_email(params)
    if settings.email_service.nil?
      puts "Sending email from #{params[:name]} <#{params[:email]}>:"
      puts ERB.new(File.read('views/contact_email_template.txt.erb')).result(binding)
    else
      require 'pony'
      Pony.mail(
        :from    => params[:name] + "<" + params[:email] + ">",
        :to      => settings.email_address,
        :subject => "[Flatterline] Contact form received from #{params[:name]}",
        :body    => ERB.new(File.read('views/contact_email_template.txt.erb')).result(binding),
        :port    => '587',
        :via     => :smtp,
        :via_options => { 
          :address              => settings.email_service,
          :port                 => '587',
          :enable_starttls_auto => true,
          :user_name            => settings.email_username,
          :password             => settings.email_password,
          :authentication       => :plain,
          :domain               => settings.email_domain
        }
      )

      puts "Sending email from #{params[:name]} <#{params[:email]}>:"
    end
  end

  def valid_email?(email)
    email =~ /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/
  end

  def validate(params)
    {}.tap do |errors|
      [:name, :email, :message].each do |key|
        params[key] = (params[key] || '').strip
        errors[key] = "This field is required" if params[key].empty?
      end

      unless params[:email].empty?
        errors[:email] = "Please enter a valid email address" unless valid_email?(params[:email])
      end
    end
  end

__END__

@@ layout
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <link href="/stylesheets/screen.css" media="screen, projection" rel="stylesheet" type="text/css" />
    <!--[if IE]>
        <link href="/stylesheets/ie.css" media="screen, projection" rel="stylesheet" type="text/css" />
    <![endif]-->

    <!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
  </head>

  <body>
    <%= yield %>
  </body>
</html>
