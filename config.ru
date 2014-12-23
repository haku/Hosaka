require 'sinatra'

SECURE = ENV['SECURE'] != 'false'

class BasicOverSsl < Rack::Auth::Basic
 def call(env)
   if env['HTTP_X_FORWARDED_PROTO'] == 'https' || !SECURE
     super
   else
     [400, {}, ['Only HTTPS is allowed.']]
   end
 end
end

class MainHandler < Sinatra::Base

  get '/' do
    send_file File.join(settings.public_folder, 'index.html')
  end

  get '/desu' do
    'Needs more desu~'
  end

end

class KamiHandler < Sinatra::Base

  def initialize
    super
    @@kami_passwd = ENV['KAMI_PASSWD']
    raise 'KAMI_PASSWD not set.' if !@@kami_passwd
  end

  use BasicOverSsl, "Protected Area" do |username, passwd|
    username == 'kami' && passwd == @@kami_passwd
  end

  get '/' do
    'Kami access desu~'
  end

end

configure do
  disable :show_exceptions
end

run Rack::URLMap.new({
  '/' => MainHandler,
  '/kami' => KamiHandler
})
