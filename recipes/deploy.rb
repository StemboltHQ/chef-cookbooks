include_recipe "stembolt_opsworks::user"

# Set up folder structure for apps
search("aws_opsworks_app").each do |app|
  prefix = "#{node[:deploy_prefix]}/#{app["shortname"]}"
  source = app["app_source"]
  release_stamp = "#{app["shortname"]}-#{Time.now.utc.strftime("%Y%m%d%H%M%S")}"
  release_dir = "#{prefix}/#{release_stamp}"

  directory release_dir do
    recursive true
    owner node[:deploy_user]
  end

  case source["type"]
  when "s3"
    s3_file "/tmp/#{release_stamp}.zip" do
      s3_url source["url"]
      aws_access_key_id source["user"]
      aws_secret_access_key source["password"]
    end

    bash "extract archive to release" do
      code <<-EOH
unzip /tmp/#{release_stamp}.zip -d #{release_dir}
      EOH
    end
  else
    raise "Unsupported app source. Only S3 archives are supported at this time."
  end

  application prefix do
    bundle_install do
      deployment true
    end

    rails do
      database node[:database_url]
      migrate true
    end

    unicorn do
      port 5000
    end
  end
end
