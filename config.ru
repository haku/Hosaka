require 'sinatra'

class MySinatra < Sinatra::Application

  def call(env)
    if env['HTTP_X_FORWARDED_PROTO'] == 'https' || ENV['SECURE'] == 'false'
      super
    else
      [400, {}, ['Only HTTPS is allowed.']]
    end
  end

end

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/desu' do
  'Needs more desu~'
end

run MySinatra
