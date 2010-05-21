set :user, "www-data"

set :repository,  "git://github.com/carr/powerdns-on-rails.git"
set :branch, "master"
#set :deploy_via, :remote_cache

set :scm, 'git'

set :deploy_to, "/var/www/d/dns.infinum.hr"
set :use_sudo, false

role :app, "vz1.infinum.hr"
role :web, "vz1.infinum.hr"
role :db,  "vz1.infinum.hr", :primary => true

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  task :symlink do
    run "rm #{current_path}/config/database.yml"
    run "ln -s #{shared_path}/database.yml #{current_path}/config/database.yml"
  end
end

after "deploy", "deploy:cleanup"
after "deploy", "deploy:symlink"
