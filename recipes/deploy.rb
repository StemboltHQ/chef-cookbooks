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
    # Opsworks makes you set a URL, but then nothing takes a URL so we need to
    # parse it. This was lifted from old Opsworks' "scm_helper" cookbook.
    # source: https://github.com/aws/opsworks-cookbooks/blob/be56268c24b86b52dd9634ccb173b9b871953c4a/scm_helper/libraries/s3.rb#L11
    # TODO: move this to a library, test it, maybe even refactor it.

    components = URI.split(source["url"])
    base_uri = URI::HTTP.new(*(components.take(5) + [nil] * 4))
    remote_path = URI::HTTP.new(*([nil] * 5 + components.drop(5)))

    virtual_host_match = base_uri.host.match(/\A(.+)\.s3(?:[-.](?:ap|eu|sa|us)-(?:.+-)\d|-external-1)?\.amazonaws\.com/i)

    if virtual_host_match
      # virtual-hosted-style: http://bucket.s3.amazonaws.com or http://bucket.s3-aws-region.amazonaws.com
      bucket = virtual_host_match[1]
    else
      # path-style: http://s3.amazonaws.com/bucket or http://s3-aws-region.amazonaws.com/bucket
      uri_path_components = remote_path.path.split("/").reject(&:empty?)
      bucket = uri_path_components.shift # cut first element
      base_uri.path = "/#{bucket}" # append bucket to base_uri
      remote_path.path = uri_path_components.join("/") # delete bucket from remote_path
    end

    # end: copypasta

    bucket_name = bucket.chomp("/")
    object_path = remote_path.to_s.sub(%r{^/}, "")

    s3_file "/tmp/#{release_stamp}.zip" do
      bucket bucket_name
      remote_path object_path
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
    owner node[:deploy_user]
    group node[:deploy_group]

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
