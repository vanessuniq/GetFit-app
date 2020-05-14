ENV["SINATRA_ENV"] ||= "development"

require './config/environment'
require 'sinatra/activerecord/rake'

# to test models and database during development. run rake console
task :console do
    Pry.start
end