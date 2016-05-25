remote_file "/tmp/ruby-#{node[:ruby_version]}.tar.gz" do
  source "https://s3.amazonaws.com/stembolt-rubies/ruby-#{node[:ruby_version]}.tar.gz"
end

directory "/usr/local/ruby"
execute "install ruby" do
  command "tar -zxf /tmp/ruby-#{node[:ruby_version]}.tar.gz -C /usr/local/ruby"
  not_if { File.exist?("/usr/local/ruby/bin/ruby") }
end
