
 require_recipe "apt"
 require_recipe "freebsd"
 require_recipe "apache2"
 require_recipe "php"
 require_recipe "openssl"
 require_recipe "mysql"
 require_recipe "mysql::server"
 require_recipe "mysql::client"
 require_recipe "apache2::mod_php5"
 require_recipe "apache2::mod_rewrite"
 require_recipe "hosts"


 execute "Install PHP Extras" do
   command "sudo apt-get install -y php5-xsl php5-dev apache2-threaded-dev"
   notifies :reload, resources(:service => "apache2"), :delayed
 end

 execute "Install pdo mysql" do
   command "sudo apt-get install -y php5-mysql"
   notifies :reload, resources(:service => "apache2"), :delayed
 end

 execute "Install GIT" do
   command "sudo apt-get install -y git"
 end

 execute "Install pdo sqlite" do
   command "sudo apt-get install -y php5-sqlite"
   notifies :reload, resources(:service => "apache2"), :delayed
 end

  execute "Install Curl" do
   command "sudo apt-get install -y curl"
  end

  execute "Install PHP CURL" do
   command "sudo apt-get install -y php5-curl"
   notifies :reload, resources(:service => "apache2"), :delayed
 end

 execute "disable-default-site" do
   command "sudo a2dissite default"
   notifies :reload, resources(:service => "apache2"), :delayed
 end

 web_app "my_site" do
   template "recensus.conf.erb"
   notifies :reload, resources(:service => "apache2"), :delayed
 end

hosts "127.0.0.1" do
  entries "localhost"
end

hosts "127.0.0.1" do
  entries "recensus.com"
end


# Update PEAR and PECL channels
php_pear "PEAR" do
  action :upgrade
end

execute "Auto discover option" do
 	user "root"
 	command "sudo pear config-set auto_discover 1"
end

phc = php_pear_channel "pear.phing.info" do
  action :discover
end

php_pear "Phing" do
  preferred_state "beta"
  channel phc.channel_name
  action :install
end

php_pear "pdo" do
  action :install
end

# Required to install APC.
package "libpcre3-dev"

# Install APC.
php_pear "apc" do
  directives(:shm_size => "128M", :write_lock => 0, :slam_defense => 0)
  version "3.1.6"
  action :install
end