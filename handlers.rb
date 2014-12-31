require 'sinatra'
require 'securerandom'
require 'json'

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

  get '/users' do
    User.all.map{|u| u.username}.join("\n")
  end

  # user details
  get '/users/:name' do |name|
    user = User.find_by(username: name)
    halt 404 if user.nil?
    {
      username: user.username,
      created_at: user.created_at,
      updated_at: user.updated_at
    }.to_json
  end

  # Create new user.
  post '/users/:name' do |name|
    halt 400, 'Invalid username.' if !/^[a-z]+$/.match(name)
    passwd = SecureRandom.uuid()
    User.create(username: name, passwd: passwd)
    {passwd: passwd}.to_json
  end

  post '/users/:name/passwdreset' do |name|
    user = User.find_by(username: name)
    halt 404 if user.nil?
    passwd = SecureRandom.uuid()
    user.update(passwd: passwd)
    {passwd: passwd}.to_json
  end

end
