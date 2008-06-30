# This is a sample Capistrano config file for EC2 on Rails.

# For our EC2 insances, applications will be deployed to "/mnt/app/#{application}

set :application, "redmine"

#set :deploy_via, :copy       # optional, see Capistrano docs for details
#set :copy_strategy, :export  # optional, see Capistrano docs for details

# set :repository, "--no-auth-cache --username tracker --password tracker http://praexis.svnrepository.com/svn/blog/trunk"

default_run_options[:pty] = true
set :repository,  "git@github.com:mully/redmine_git.git"
set :scm, "git"

# it's logging in as the "app" user
# set :scm_passphrase, "LetsRoll!" #This is your custom users password
# set :user, "deployer"

# This will specify the branch that gets checked out for the deployment.
set :branch, "origin/master"

# Remote caching will keep a local git repo on the server youâ€™re deploying to and simply run a fetch from that rather than an 
# entire clone. This is probably the best option and will only fetch the differences each deploy
set :deploy_via, :remote_cache

# NOTE: for some reason Capistrano requires you to have both the public and
# the private key in the same folder, the public key should have the 
# extension ".pub".
home = `echo $HOME`.split("\n")[0]

ssh_options[:keys] = "#{home}/.ec2/jim-ssh"

# set :user, "admin"

# Your EC2 instances
role :web, "squeejee.dyndns.org"
role :app, "squeejee.dyndns.org"
role :db,  "squeejee.dyndns.org", :primary => true

desc "Reset symlink to public/files directory to not overwrite uploaded store images."
task :after_symlink, :roles => [ :app, :db, :web ] do
  run "ln -nfs #{deploy_to}shared/system/files #{release_path}"
end

# EC2 on Rails config
set :ec2onrails_config, {
  # S3 bucket used by the ec2onrails:db:archive task
  :restore_from_bucket => "db.praexis.com",
  
  # S3 bucket used by the ec2onrails:db:restore task
  :archive_to_bucket => "db.praexis.com",
  
  # Set a root password for MySQL. Run "cap ec2onrails:db:set_root_password"
  # to enable this. This is optional, and after doing this the
  # ec2onrails:db:drop task won't work, but be aware that MySQL accepts 
  # connections on the public network interface (you should block the MySQL
  # port with the firewall anyway). 
  :mysql_root_password => "dilb3rt!",
  
  # Any extra Ubuntu packages to install if desired
  #:packages => %w(logwatch imagemagick),
  
  # Any extra RubyGems to install if desired
  :rubygems => %w(tzinfo),
  
  # Set the server timezone. run "cap -e ec2onrails:server:set_timezone" for details
  :timezone => "America/Chicago",
  
  # Files to deploy to the server, It's intended mainly for
  # customized config files for new packages installed via the 
  # ec2onrails:server:install_packages task. 
  #:server_config_files_root => "../server_config",
  
  # If config files are deployed, some services might need to be restarted
  #:services_to_restart => %w(apache2 postfix sysklogd)
}
