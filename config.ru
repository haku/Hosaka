require 'sinatra'
require './environments'
require './data'
require './handlers'

use Rack::Deflater

run Rack::URLMap.new({
  '/' => PublicHandler,
  '/me' => MeHandler,
  '/kami' => KamiHandler
})
