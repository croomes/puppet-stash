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
class stash::install {

  require stash::params

  case $::osfamily {
    'Darwin' : { # assuming you did download wget - ill maybe fix this and check for it
      exec { 'wget-stash-package':
        cwd     => "${stash::params::tmpdir}",
        command => "${stash::params::cmdwget} --no-check-certificate ${stash::params::downloadURL}",
        creates => "${stash::params::tmpdir}/atlassian-${stash::params::product}-${stash::params::version}.${stash::params::format}",
      }
    }
    default : {
      exec { 'wget-stash-package':
        cwd     => "${stash::params::tmpdir}",
        command => "${stash::params::cmdwget} --no-check-certificate ${stash::params::downloadURL}",
        creates => "${stash::params::tmpdir}/atlassian-${stash::params::product}-${stash::params::version}.${stash::params::format}",
      }
    }
  }

  exec { 'mkdirp-installdir':
    cwd     => "${stash::params::tmpdir}",
    command => "/bin/mkdir -p ${stash::params::installdir}",
    creates => "${stash::params::installdir}",
  }
  exec { 'unzip-stash-package':
    cwd     => "${stash::params::installdir}",
    command => "/usr/bin/unzip -o -d ${stash::params::installdir} ${stash::params::tmpdir}/atlassian-${stash::params::product}-${stash::params::version}.${stash::params::format}",
    creates => "${stash::params::webappdir}",
    require => [Exec['wget-stash-package'],Exec['mkdirp-installdir']],
  }

  file { '/etc/rc.d/init.d/stash':
    content => template('stash/etc/rc.d/init.d/stash.erb'),
    mode    => '0755',
  }
  file { '/etc/rc3.d/S99stash':
    ensure  => link,
    target  => '/etc/rc.d/init.d/stash',
    require => File['/etc/rc.d/init.d/stash'],
  }
}
