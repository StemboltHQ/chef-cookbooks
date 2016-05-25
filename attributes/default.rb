# General Deployment
node.default[:deploy_user] = "deploy"
node.default[:deploy_group] = "deploy"

# Ruby

node.default[:ruby_version] = "2.3.1"
node.default[:ruby_prefix] = "/usr/local/ruby"

if ["ubuntu", "debian"].include?(node["platform"])
  node.default[:bashrc_location] = "/etc/bash.bashrc"
else
  node.default[:bashrc_location] = "/etc/bashrc"
end
