# encoding: UTF-8
require "bundler/capistrano"
require File.dirname(__FILE__) + "/password_yml_files"

ssh_options[:forward_agent] = true
set :application, "tt_register"
set :repository,  "git@github.com:Patru/tt-register.git"
set :domain, "tt.soft-werker.ch"                           # The URL for your app
set :scm_verbose, true

set :scm, 'git'
set :scm_username, "patru"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :branch, "master"
set :deploy_via, :copy
set :deploy_to, "/home/soft-werker/app/tt"
set :use_sudo, false

set :user, 'soft-werker'

role :web, "ssh.alwaysdata.com"                          # Your HTTP server, Apache/etc
role :app, "ssh.alwaysdata.com"                          # This may be the same as your `Web` server
role :db,  "ssh.alwaysdata.com", :primary => true        # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end