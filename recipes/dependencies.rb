package "git"
package "unzip"

if ["debian", "ubuntu"].include?(node["platform"])
  # Debian/Ubuntu doesn't update its mirrors before installing things, so we
  # could run into a situation where the indexes are out of date and package
  # start 404ing.
  execute "apt-get update"
end

if ["centos", "amazon", "redhat"].include?(node["platform"])
  package "ed"
end

package "install development tools" do
  case node["platform"]
  when "redhat", "centos", "amazon"
    # Since chef doesn't support yum groups, we have to list every package
    # individually. This was pulled directly from the "required" list of the "C
    # Development Tools and Libraries" group on Fedora 23.
    package_name [
      "autoconf",
      "automake",
      "binutils",
      "bison",
      "flex",
      "gcc",
      "gcc-c++",
      "gdb",
      "glibc-devel",
      "libtool",
      "make",
      "pkgconfig",
      "strace"
    ]
  when "debian", "ubuntu"
    package_name "build-essential"
  end
end

package "common rails gem extensions" do
  case node["platform"]
  when "centos", "redhat", "amazon"
    package_name ["libxml2-devel", "libxslt-devel"]
  when "ubuntu", "debian"
    package_name ["libxml2-dev", "libxslt-dev"]
  end
end

package "ruby dependencies" do
  case node["platform"]
  when "ubuntu", "debian"
    package_name ["zlib1g-dev", "libyaml-dev", "libssl-dev", "libgdbm-dev", "libreadline-dev", "libncurses5-dev", "libffi-dev"]
  when "redhat", "centos", "amazon"
    package_name ["zlib-devel", "libyaml-devel", "openssl-devel", "gdbm-devel", "readline-devel", "ncurses-devel", "libffi-devel"]
  end
end

# TODO: make each of these optionally installed via a data bag attribute
package "install mysql headers" do
  case node["platform"]
  when "centos", "redhat", "amazon"
    package_name "mysql-devel"
  when "ubuntu", "debian"
    package_name "libmysqld-dev"
  end
end

package "install sqlite headers" do
  case node["platform"]
  when "centos", "redhat", "amazon"
    package_name "sqlite-devel"
  when "ubuntu", "debian"
    package_name "libsqlite3-dev"
  end
end

package "install postgresql headers" do
  case node["platform"]
  when "centos", "redhat", "amazon"
    package_name "postgresql-devel"
  when "ubuntu", "debian"
    package_name "libpq-dev"
  end
end
