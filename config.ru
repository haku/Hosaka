class MyStatic < Rack::Static

  def call(env)
    if env['HTTP_X_FORWARDED_PROTO'] == 'https' || ENV['SECURE'] == 'false'
      super
    else
      [400, {}, ['Only HTTPS is allowed.']]
    end
  end

end

run MyStatic.new @app,
  :urls => [""],
  :root  => "public",
  :index => 'index.html'
