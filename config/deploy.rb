# config valid for current version and patch releases of Capistrano
lock "~> 3.10.2"

set :application, "myblog"
set :repo_url, "git@github.com:puping94/myblog.git"

# Default branch is :master
ask :branch, 'master'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/myblog"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
append :linked_dirs, 'bin', "log", "tmp/pids", "tmp/cache", "tmp/sockets"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Rails options
# Skip migration if files in db/migrate were not modified, Defaults to false
set :conditionally_migrate, true

# If you need to touch public/images, public/javascripts, and public/stylesheets on each deploy
#set :normalize_asset_timestamps, %w{public/images public/javascripts public/stylesheets}

# Default value for keep_releases is 5
set :keep_releases, 5
set :pty, true

set :use_sudo, false
set :deploy_via, :remote_cache
set :stages, %w[integration production]

set :puma_threds,  [4, 16]
set :puma_workers, 0
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"

set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub), port: 22 }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  task :make_shared_dir do
    on roles(:app) do
      execute "mkdir #{shared_path}"
    end
  end

  before :start, :make_dirs
  before :config, :make_shared_dir
end
#
# task :restart_sidekiq do
#   on roles(:worker) do
#     execute :service, "sidekiq restart"
#   end
# end
#
# after "deploy:published", "restart_sidekiq"