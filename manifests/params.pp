#-----------------------------------------------------------------------------
#   Copyright (c) 2012 Bryce Johnson
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#-----------------------------------------------------------------------------
class stash::params {
  # resource types do not allow hiera to be expressed directly
  # so continuing to use params.pp as a variable holder
  # they are also required for the var lookup for the templates
  $version      = hiera('stash_version')
  $product      = hiera('stash_name')
  $format       = hiera('stash_package_format')
  $installdir   = hiera('stash_install_dir')
  $webappdir    = "${installdir}/atlassian-${product}-${version}"
  $homedir      = hiera('stash_home_dir')

  # Database Settings
  $db           = hiera('stash_db')
  $dbuser       = hiera('stash_dbuser')
  $dbpassword   = hiera('stash_dbpassword')
  $dbserver     = hiera('stash_dbserver')
  $dbport       = hiera('stash_dbport')
  $dbdriver     = hiera('stash_dbdriver')
  $dburl        = "jdbc:${db}://${dbserver}:${dbport}/stash"

  # JVM Settings
  $javahome     = hiera('stash_javahome')
  $jvm_xmx      = hiera('stash_jvm_xmx')
  $jvm_optional = hiera('stash_jvm_optional')

  # With my experience, this URL shouldn't ever change and can be
  # used for all Atlassian products, their versions, and file format.
  # It's also cdn cached. :)
  # TODO: maybe toss this into atlassian.yaml for hiera
  $downloadURL = "http://www.atlassian.com/software/${product}/downloads/binary/atlassian-${product}-${version}.${format}"

  case $::osfamily {
    'Darwin' : {
      # HTFU macboy - go download and install wget
      $cmdwget = '/usr/local/bin/wget'
      $tmpdir  = '/tmp'
    }
    default : {
      $cmdwget = '/usr/bin/wget'
      $tmpdir  = '/tmp'
    }
  }
}
