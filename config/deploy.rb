#############################################################
#	Application
#############################################################

set :application, "redmine"
set :deploy_to, "/mnt/app/#{application}"

#############################################################
#	Settings
#############################################################

default_run_options[:pty] = true
set :use_sudo, false

#############################################################
#	Servers
#############################################################

set :user, "app"
set :domain, "tracker.squeejee.com"
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
#	SCM
#############################################################

default_run_options[:pty] = true
set :repository,  "git@github.com:squeejee/redmine.git"
set :scm, "git"
set :branch, "master"

#############################################################
#	Passenger
#############################################################

namespace :deploy do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

desc "Reset symlink to public/files directory to not overwrite uploaded store images."
task :after_update_code, :roles => [ :app, :db, :web ] do
	copy_config_files
end

desc "Create Shared directory and subdirectories;"
task :create_shared_directory, :roles => :app do
	run "mkdir -p #{deploy_to}/shared/config; mkdir -p #{deploy_to}/shared/system/files; mkdir -p #{deploy_to}/shared/log;"
end

desc "Copy config files local to deployment site into deployed rails config directory"
task :copy_config_files, :roles => :app do
  create_shared_directory
  run "cp #{deploy_to}/shared/config/* #{release_path}/config/"
end

desc "Update git submodules"
task :update_submodules, :roles => :app do
  run "cd #{deploy_to}/current; git submodule init; git submodule update;"
end

desc "Reset symlink to public/files directory to not overwrite uploaded store images."
task :after_symlink, :roles => [ :app, :db, :web ] do
  run "ln -nfs #{deploy_to}/shared/system/files #{release_path}/files"
end


