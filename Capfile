# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require "capistrano/bundler"
require "capistrano/rails/assets"
require "capistrano/rails/migrations"
# require "capistrano/rvm"
# require "capistrano/chruby"
# require "capistrano/passenger"

require 'capistrano/puma'
install_plugin Capistrano::Puma, load_hooks: false  # Default puma tasks without hooks
#install_plugin Capistrano::Puma::Workers  # if you want to control the workers (in cluster mode)
#install_plugin Capistrano::Puma::Jungle # if you need the jungle tasks
#install_plugin Capistrano::Puma::Monit, load_hooks: false   # if you need the monit tasks
#install_plugin Capistrano::Puma::Nginx  # if you want to upload a nginx site template

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
