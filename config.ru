require 'dotenv'
require_relative 'app/router'

Dotenv.load

run Router.new