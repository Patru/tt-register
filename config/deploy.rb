# encoding: UTF-8
# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, "tt_register"
set :repo_url,"git@github.com:Patru/tt-register.git"
set :domain, "tt.soft-werker.ch"                           # The URL for your app

set :deploy_to, "/home/soft-werker/app/tt"
# Default deploy_to directory is /var/www/my_app

set :scm_verbose, true
set :scm, 'git'
set :scm_username, "patru"
# Default value for :scm is :git

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

#set :stage, :production
#set :user, 'soft-werker'

#role :web, "ssh-soft-werker.alwaysdata.net"                          # Your HTTP server, Apache/etc
#role :app, "ssh-soft-werker.alwaysdata.net"                          # This may be the same as your `Web` server
#role :db,  "ssh-soft-werker.alwaysdata.net", :primary => true        # This is where Rails migrations will run

#set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,#ssh_options[:forward_agent] = true
#}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
  #  run "touch #{current_path}/tmp/restart.txt" (this we had on alwaysdata for capistrano 2.0
       execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end


# encoding: UTF-8
#require "bundler/capistrano"
#require File.dirname(__FILE__) + "/password_yml_files"

#ssh_options[:forward_agent] = true
#set :application, "tt_register"
#set :repository,  "git@github.com:Patru/tt-register.git"
#set :domain, "tt.soft-werker.ch"                           # The URL for your app
#set :scm_verbose, true

#set :scm, 'git'
#set :scm_username, "patru"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
#set :branch, "master"
#set :deploy_to, "/home/soft-werker/app/tt"
#set :use_sudo, false

#set :user, 'soft-werker'

#role :web, "ssh-soft-werker.alwaysdata.net"                          # Your HTTP server, Apache/etc
#role :app, "ssh-soft-werker.alwaysdata.net"                          # This may be the same as your `Web` server
#role :db,  "ssh-soft-werker.alwaysdata.net", :primary => true        # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

#namespace :deploy do
#  desc "Restarting mod_rails with restart.txt"
#  task :restart, :roles => :app, :except => { :no_release => true } do
#    run "touch #{current_path}/tmp/restart.txt"
#  end

#  [:start, :stop].each do |t|
#    desc "#{t} task is a no-op with mod_rails"
#    task t, :roles => :app do ; end
#  end
#end

