name 'my_chef_client'
maintainer 'GB'
maintainer_email 'gus@gmail.com'
license 'Apache-2.0'
description 'Installs/Configures my_chef_client'
long_description 'Installs/Configures my_chef_client'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)
depends 'chef-client'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/<insert_org_here>/my_chef_client/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/<insert_org_here>/my_chef_client'
