class adt_installer {
  require tools
  class { 'staging':
    path => '/var/staging',
    owner => 'vagrant',
    group => 'vagrant',
  }

  staging::file { 'adt_installer.tar.bz2':
    source => 'http://britannica.tw.it/decos/adt_installer.tar.bz2'
  }

  file { "/tmp/staging":
      owner => 'vagrant',
      ensure => "directory",
  }

  staging::extract { 'adt_installer.tar.bz2':
    user => 'vagrant',
    target => '/tmp/staging',
    creates => '/tmp/staging/adt_installer',
    require => Staging::File['adt_installer.tar.bz2'],
  }

  file { '/tmp/staging/adt-installer/adt_installer.conf':
    path   => '/tmp/staging/adt-installer/adt_installer.conf',
    owner => 'vagrant',
    group => 'vagrant',
    ensure => file,
    source => "puppet:///modules/adt_installer/adt_installer.conf",
    require => Staging::Extract['adt_installer.tar.bz2']
  }

  exec { 'Install ADT':
    cwd => '/tmp/staging/adt-installer',
    user => 'vagrant',
    command => "/bin/echo -e -n '/opt/poky/1.5.1\nS\n' | /tmp/staging/adt-installer/adt_installer",
    timeout => 0,
    require => File['/tmp/staging/adt-installer/adt_installer.conf']
  }
}
