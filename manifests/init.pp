class yocto-adt-installer {
  require tools
  class { 'staging':
    path => '/var/staging',
    owner => 'vagrant',
    group => 'vagrant',
  }

  staging::file { 'adt_installer.tar.bz2':
    #source => 'http://britannica.tw.it/decos/adt_installer.tar.bz2'
    source => 'http://gizero-desktop.tw.it/adtrepo/sdk/adt_installer.tar.bz2'
  }

  staging::extract { 'adt_installer.tar.bz2':
    user => 'vagrant',
    target => '/var/staging',
    creates => '/var/staging/adt_installer',
    require => Staging::File['adt_installer.tar.bz2'],
  }

#  file { '/var/staging/adt-installer/adt_installer.conf':
#    path   => '/var/staging/adt-installer/adt_installer.conf',
#    owner => 'vagrant',
#    group => 'vagrant',
#    ensure => file,
#    source => "puppet:///modules/yocto-adt-installer/adt_installer.conf",
#    require => Staging::Extract['adt_installer.tar.bz2']
#  }
#
  exec { 'Install ADT':
    cwd => '/var/staging/adt-installer',
    user => 'vagrant',
    command => "/bin/echo -e -n '/opt/poky/1.5.1\nS\n' | /var/staging/adt-installer/adt_installer",
    timeout => 0,
    require => Staging::Extract['adt_installer.tar.bz2']
#    require => File['/var/staging/adt-installer/adt_installer.conf']
  }

# remove archive to force downloading again next time
  exec { 'Cleanup':
    command => 'rm /var/staging/yocto-adt-installer/adt_installer.tar.bz2',
    require => Staging::Extract['adt_installer.tar.bz2']
  }
}
