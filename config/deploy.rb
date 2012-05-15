require "rvm/capistrano"  # Load RVM's capistrano plugin.
require "bundler/capistrano" # Bundler will be activated after each new deployment

set :use_sudo, false

set :application, "danthought.ideasbulb.com" # Set Application Name
set :repository,  "git://github.com/danjiang/ideasbulb.git" # Set Source Code Repository
set :scm, :git # Set SCM

set :deploy_to, "/var/www/danthought.ideasbulb.com" # Deployed Server Directory

role :app, application # Set Application Server Address
role :web, application # Set Web Server Address
role :db,  application, :primary => true # Set Database Server Address

set :rvm_type, :system  # Copy the exact line. I really mean :system here
set :rvm_ruby_string, 'ruby-1.9.2-p290@ideasbulb' # Set RVM Env You Want App To Run In

namespace :foreman do
  desc "Start the application services"
  task :start, :roles => :app do
    sudo "start #{application}"
  end

  desc "Stop the application services"
  task :stop, :roles => :app do
    sudo "stop #{application}"
  end

  desc "Restart the application services"
  task :restart, :roles => :app do
    run "sudo start #{application} || sudo restart #{application}"
  end

  desc "Display logs for a certain process - arg example: PROCESS=web-1"
  task :logs, :roles => :app do
    run "cd #{current_path}/log && cat #{ENV["PROCESS"]}.log"
  end

  desc "Export the Procfile to upstart scripts"
  task :export, :roles => :app do
    run "cd #{release_path} && rvmsudo bundle exec foreman export upstart /etc/init -a #{application} #{shared_path}/log  -f #{release_path}/Procfile.production -c worker=2"
  end 
end

namespace :deploy do

  desc "Symlink extra configs and folders."
  task :symlink_extras do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/app_config.yml #{release_path}/config/app_config.yml"
  end

  desc "Setup shared directory."
  task :setup_shared do
    run "mkdir -p #{shared_path}/config"
    # Read Local File and Upload
    put File.read("config/examples/database.yml"), "#{shared_path}/config/database.yml"
    put File.read("config/examples/app_config.yml"), "#{shared_path}/config/app_config.yml"
  end

  desc "Restarts your application."
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

end

# $ cap deploy:setup -S skip_setup_shared=true
after "deploy:setup", "deploy:setup_shared" unless fetch(:skip_setup_shared, false)
after "deploy:setup", "foreman:export"
before "deploy:assets:precompile", "deploy:symlink_extras"
after "deploy:update_code", "deploy:migrate"
