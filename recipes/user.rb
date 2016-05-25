group "deploy"
user "deploy" do
  shell "/bin/bash"
  group "deploy"
  manage_home true
end
