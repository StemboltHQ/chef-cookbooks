# Install Ruby dependencies
# Even though we compile elsewhere, we still need the library headers to link to
package "ruby dependencies" do
  case node["platform"]
  when "ubuntu", "debian"
    package_name ["zlib1g-dev", "libyaml-dev", "libssl-dev", "libgdbm-dev", "libreadline-dev", "libncurses5-dev", "libffi-dev"]
  when "redhat", "centos", "amazon"
    package_name ["zlib-devel", "libyaml-devel", "openssl-devel", "gdbm-devel", "readline-devel", "ncurses-devel", "libffi-devel"]
  end
end

remote_file "/tmp/ruby-#{node[:ruby_version]}.tar.gz" do
  case node["platform"]
  when "ubuntu", "debian"
    source "https://s3.amazonaws.com/stembolt-rubies/ruby-#{node[:ruby_version]}-ubuntu.tar.gz"
  when "redhat", "centos", "amazon"
    source "https://s3.amazonaws.com/stembolt-rubies/ruby-#{node[:ruby_version]}-rhel.tar.gz"
  end
end

directory node[:ruby_prefix]

execute "install ruby" do
  command "tar -zxf /tmp/ruby-#{node[:ruby_version]}.tar.gz -C #{node[:ruby_prefix]}"
  not_if { File.exist?("#{node[:ruby_prefix]}/bin/ruby") }
end

bash "insert ruby into bashrc" do
  # Since on Debian-based distros it aborts at the top if it's non-interactive,
  # we can't just append a line, we need to hack it into the top. Thanks, Debian.
  code <<EOR
ed #{node[:bashrc_location]} <<EOF
0a
export PATH=#{node[:ruby_prefix]}/bin:$PATH
.
wq
EOF
EOR
end
