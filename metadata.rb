name 'barito-agent'
maintainer 'BaritoLog'
maintainer_email 'you@example.com'
license 'MIT'
description 'Installs/Configures Barito Agent'
long_description 'Installs/Configures Barito Agent'
version '0.4.4'
chef_version '>= 12.12' if respond_to?(:chef_version)

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
issues_url 'https://github.com/BaritoLog/barito-agent-cookbook/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
source_url 'https://github.com/BaritoLog/barito-agent-cookbook'

depends 'td-agent', '~> 3.0'
