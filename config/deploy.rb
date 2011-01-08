set :application, "tt_tournament_register"
set :repository,  "git@git.assembla.com:soft-werker-ttt.git"
set :domain, "patru.ch/ttt"                           # The URL for your app

set :scm, 'git'
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :deploy_to, "/home/sites/patru.ch/ttt.dep"
set :rails_env, :production

role :web, "patru.ch"                          # Your HTTP server, Apache/etc
role :app, "patru.ch"                          # This may be the same as your `Web` server
role :db,  "patru.ch", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"
set :user, "patru.ch"
set :scm_username, "Patru"
set :scm_password, Proc.new { Capistrano::CLI.password_prompt("git password for #{scm_username}, please: ") }
set :use_sudo, false
set :deploy_via, :copy
set :copy_strategy, :export
set :copy_cache, true
set :copy_cache, "/tmp/caches/ttt"
set :copy_exclude, [".git/*", ".svn/*"]
set :copy_compression, :gzip
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
    run "sed -e \"s/^# ENV/ENV/\" -i #{release_path}/tt-register/config/environment.rb"
end
