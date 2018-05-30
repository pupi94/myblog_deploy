# config valid for current version and patch releases of Capistrano
lock "~> 3.10.2"

set :application, "myblog"
set :repo_url, "git@github.com:puping94/myblog.git"

# Default branch is :master
ask :branch, 'master'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/myblog"

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
set :pty, false

# puma相关配置
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

# sidekiq相关配置
# ensure this path exists in production before deploying.
set :sidekiq_pid, File.join(shared_path, 'tmp', 'pids', 'sidekiq.pid')
set :sidekiq_env, fetch(:rack_env, fetch(:rails_env, fetch(:stage)))
set :sidekiq_log, File.join(shared_path, 'log', 'sidekiq.log')
set :sidekiq_config, "#{current_path}/config/sidekiq.yml"
#set :sidekiq_options_per_process, ["--queue critical", "--queue default --queue low"]

set :sidekiq_role, :app
set :sidekiq_monit_use_sudo, false

# sidekiq monit
set :sidekiq_monit_conf_dir, '/etc/monit/conf.d'
set :monit_bin, '/usr/bin/monit'

set :service_unit_name, "sidekiq-#{fetch(:application)}-#{fetch(:stage)}.service"

SSHKit.config.command_map[:sidekiq] = "bundle exec sidekiq"
SSHKit.config.command_map[:sidekiqctl] = "bundle exec sidekiqctl"

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