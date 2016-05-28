package "git"

if ["centos", "amazon", "redhat"].include?(node["platform"])
  package "ed"
end
