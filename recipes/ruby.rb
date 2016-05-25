remote_file "/tmp/ruby-#{node[:ruby_version]}.tar.gz" do
  source "https://s3.amazonaws.com/stembolt-rubies/ruby-#{node[:ruby_version]}.tar.gz"
end

directory node[:ruby_prefix]
execute "install ruby" do
  command "tar -zxf /tmp/ruby-#{node[:ruby_version]}.tar.gz -C #{node[:ruby_prefix]}"
  not_if { File.exist?("#{node[:ruby_prefix]}/bin/ruby") }
end
