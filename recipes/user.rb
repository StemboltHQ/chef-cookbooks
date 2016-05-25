# Create deployment user
group node[:deploy_group]
user node[:deploy_user] do
  shell "/bin/bash"
  group node[:deploy_group]
  manage_home true
end
