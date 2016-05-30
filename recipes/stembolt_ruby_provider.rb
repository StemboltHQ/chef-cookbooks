require 'chef/mixin/shell_out'
require 'poise_ruby/ruby_providers/base'

module PoiseRuby
  module Stembolt
    # Inversion provider for `ruby_runtime` to install via our custom tars.
    #
    # @since 1.0.0
    # @provides stembolt
    class Provider < ::PoiseRuby::RubyProviders::Base
      include Chef::Mixin::ShellOut
      provides(:stembolt)

      # Path to the compiled Ruby binary.
      #
      # @return [String]
      def ruby_binary
        ::File.join(node[:ruby_prefix], "bin", "ruby")
      end

      private

      # Install the Ruby runtime from our tarball
      #
      # @return [String] path to Ruby executable
      def install_ruby
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
          not_if { ::File.exist?("#{node[:ruby_prefix]}/bin/ruby") }
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

        "#{options[:ruby_prefix]}/bin/ruby"
      end

      # Uninstall the Ruby runtime.
      def uninstall_ruby
        execute "rm -rf #{node[:ruby_prefix]}/ruby"
      end
    end

    # Install the "bundler" rubygem
    def install_bundler
      bash "install bundler" do
        code "/usr/local/ruby/bin/gem install bundler --no-ri --no-rdoc"
      end
    end
  end
end
