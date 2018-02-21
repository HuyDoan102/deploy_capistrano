# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, 'l5'

# set :repo_url, "git@example.com:me/my_repo.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, ENV['branch'] || 'develop'

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto
set :log_level, :debug
# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
namespace :deploy do

    desc 'example'
    task :production do
        on roles(:web) do
            set :repo_url, 'https://github.com/HuyDoan102/l5_Repository.git'
            set :deploy_to, '/var/www/l5_Repository'
            set :linked_files, fetch(:linked_files, []).push('.env')
            # set :linked_dirs, fetch(:linked_dirs, []).push('storage', 'vendor')

            # set :linked_dirs, fetch(:linked_dirs, []).push(
            #   "storage",
            #   "storage/app",
            #   # "storage/app/public",
            #   "storage/framework",
            #   "storage/framework/cache",
            #   "storage/framework/sessions",
            #   "storage/framework/views",
            #   "storage/logs"
            # )
            set('shared_dirs', [
                'storage/app',
                'storage/framework/cache',
                'storage/framework/sessions',
                'storage/framework/views',
                'storage/logs',
            ]);
            # set :file_permissions_paths, ["public/temp"]

            invoke :deploy
        end
    end

    after :production, 'composer:update'
    after :production, 'composer:dump_autoload'

    after :production, 'laravel:migrate'
    after :production, 'laravel:permissions'

end