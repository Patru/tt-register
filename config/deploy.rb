default_run_options[:pty] = true  # Must be set for the password prompt from git to work
ssh_options[:username]="p35548r0"
ssh_options[:forward_agent] = true
set :application, "tt_register"
set :repository,  "git@git.assembla.com:soft-werker-tt-register.git"
set :domain, "tt.soft-werker.ch"                           # The URL for your app

set :scm, 'git'
set :scm_username, "patru"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :branch, "master"
set :deploy_via, :remote_cache
set :deploy_to, "/home/p35548r0/app/tt"
set :rails_env, :production
set :use_sudo, false

role :web, "soft-werker.ch"                          # Your HTTP server, Apache/etc
role :app, "soft-werker.ch"                          # This may be the same as your `Web` server
role :db,  "soft-werker.ch", :primary => true        # This is where Rails migrations will run
#role :db,  "your slave db-server here"

desc "Set the proper permissions for directories and files on the HostingRails accounts"
set :chmod755, %w(app config db lib public vendor script tmp public/dispatch.cgi public/dispatch.fcgi public/dispatch.rb)
task :after_deploy do
  run(chmod755.collect do |item|
    "chmod 755 #{current_path}/#{item}"
  end.join(" && "))
end

set :group_writable, false

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start {}
#   task :stop {}
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
task :after_update_code, :roles => :app do
    run "sed -e \"s/^# ENV/ENV/\" -i #{release_path}/config/environment.rb"
end

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