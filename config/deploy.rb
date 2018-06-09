# config valid for current version and patch releases of Capistrano
lock "~> 3.10.2"

set :application, "myblog"
set :repo_url, "git@github.com:puping94/myblog.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/myblog"

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/master.key"

# Default value for linked_dirs is []
append :linked_dirs, 'bin', "log", "tmp/pids", "tmp/cache", "tmp/sockets", 'public/system'

# If the environment differs from the stage name
set :rails_env, 'production'

# Skip migration if files in db/migrate were not modified, Defaults to false
set :conditionally_migrate, true

set :use_sudo, false

set :pty, false

# puma相关配置
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_conf, "#{shared_path}/puma.rb"

set :puma_preload_app, true
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
# 生成的monit配置存放路径，一定要确认 production 服务器上 monitrc这个文件中有包含此路径
# eg：include /etc/monit/conf.d/*
set :sidekiq_monit_conf_dir, '/etc/monit/conf.d'
# monit安装路径
set :monit_bin, '/usr/bin/monit'

set :service_unit_name, "sidekiq-#{fetch(:application)}-#{fetch(:stage)}.service"

SSHKit.config.command_map[:sidekiq] = "bundle exec sidekiq"
SSHKit.config.command_map[:sidekiqctl] = "bundle exec sidekiqctl"