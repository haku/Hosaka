require 'sinatra'
require './environments'
require './data'
require './handlers'

run Rack::URLMap.new({
  '/' => MainHandler,
  '/kami' => KamiHandler
})
