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

class UserUtils

  def self.valid_username?(name)
    /^[a-z]+$/.match(name)
  end

end

class PublicHandler < Sinatra::Base

  get '/' do
    send_file File.join(settings.public_folder, 'index.html')
  end

  get '/desu' do
    'Needs more desu~'
  end

end

class MeHandler < Sinatra::Base

  use BasicOverSsl, "Protected Area" do |username, passwd|
    if UserUtils.valid_username?(username)
      user = User.find_by(username: username)
      if user.nil?
        false
      else
        passwd.length > 0 && passwd == user.passwd
      end
    else
      false
    end
  end

  get '/' do
    name = request.env["REMOTE_USER"]
    "Me access for '#{name}' desu~"
  end

  def user_columns(user)
    user.columns.each_with_object({}) do |c, h|
      h[c.column_hash] = c
    end
  end

  def user_columns_as_hashes(user)
    user.columns.each_with_object({}) do |c, h|
      h[c.column_hash] = {
        item_id: c.item_id,
        item_time: c.item_time,
        unread_time: c.unread_time
      }
    end
  end

  get '/columns' do
    name = request.env["REMOTE_USER"]
    user_columns_as_hashes(User.find_by(username: name)).to_json
  end

  post '/columns' do
    name = request.env["REMOTE_USER"]

    request.body.rewind
    new_cols = JSON.parse(request.body.read)

    user = User.find_by(username: name)
    Column.transaction do
      est_cols = user_columns(user)

      new_cols.each do |hash, unsafe_new_col|
        new_col = {
          # TODO validate hash is not silly.
          column_hash: hash,
          # TODO validate item_id is not silly.
          item_id:     unsafe_new_col['item_id'],
          # TODO replace .to_i with some actual validation.
          item_time:   unsafe_new_col['item_time'].to_i,
          unread_time: unsafe_new_col['unread_time'].to_i
        }

        est_col = est_cols[hash]
        if est_col
          if new_col[:item_time] > est_col[:item_time]
            est_col.item_id   = new_col[:item_id]
            est_col.item_time = new_col[:item_time]
          end

          if new_col[:unread_time] > est_col[:unread_time]
            est_col.unread_time = new_col[:unread_time]
          end

          est_col.save! # seems AR knows to do nothing if no changes.
        else
          Column.create(new_col.merge(user: user))
        end
      end
    end

    user_columns_as_hashes(user).to_json
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
    halt 400, 'Invalid username.' unless UserUtils.valid_username?(name)
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
