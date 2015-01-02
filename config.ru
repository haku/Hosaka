require 'sinatra'
require './environments'
require './data'
require './handlers'

run Rack::URLMap.new({
  '/' => PublicHandler,
  '/me' => MeHandler,
  '/kami' => KamiHandler
})
