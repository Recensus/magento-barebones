
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
 require_recipe "xdebug"
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

  execute "Install PHP Mcrypt" do
   command "sudo apt-get install -y php5-mcrypt"
   notifies :reload, resources(:service => "apache2"), :delayed
 end

  execute "Install PHP GD" do
   command "sudo apt-get install -y php5-gd"
   notifies :reload, resources(:service => "apache2"), :delayed
 end

 execute "disable-default-site" do
   command "sudo a2dissite default"
   notifies :reload, resources(:service => "apache2"), :delayed
 end

web_app "dev.magento-test.com" do
   template "magento-test.conf.erb"
   notifies :reload, resources(:service => "apache2"), :delayed
end

web_app "dev.magento-test-data.com" do
   template "magento-test-data.conf.erb"
   notifies :reload, resources(:service => "apache2"), :delayed
end

hosts "127.0.0.1" do
  entries ["localhost", "dev.magento-test.com", "dev.magento-test-data.com"]
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

 execute "allow external db access" do
   command "echo  \"GRANT ALL PRIVILEGES ON *.* to 'root'@'%' IDENTIFIED BY '' WITH GRANT OPTION; FLUSH PRIVILEGES;\" | mysql -uroot"
 end

 execute "create db 1" do
   command "echo 'CREATE DATABASE \`magento-test\`' | mysql -uroot"
 end

 execute "create db 2" do
   command "echo 'CREATE DATABASE \`magento-test-data\`' | mysql -uroot"
 end

 execute "populate db 2" do
   command "mysql -uroot -Dmagento-test-data < /vagrant/magento-sample-data-1.6.1.0/magento_sample_data_for_1.6.1.0.sql"
 end