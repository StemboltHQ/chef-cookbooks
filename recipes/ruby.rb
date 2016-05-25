remote_file "/tmp/ruby-#{node[:ruby_version]}.tar.gz" do
  source "https://s3.amazonaws.com/stembolt-rubies/ruby-#{node[:ruby_version]}.tar.gz"
end

directory node[:ruby_prefix]

execute "install ruby" do
  command "tar -zxf /tmp/ruby-#{node[:ruby_version]}.tar.gz -C #{node[:ruby_prefix]}"
  not_if { File.exist?("#{node[:ruby_prefix]}/bin/ruby") }
end

bash "insert ruby into bashrc" do
  # Since on Debian-based distros it aborts at the top if it's non-interactive,
  # we can't just append a line, we need to hack it into the top. Thanks, Debian.
  code <<-EOR
ed /etc/bash.bashrc <<EOF
0a
export PATH=#{node[:ruby_prefix]}/bin:$PATH
.
wq
EOF
EOR
end
