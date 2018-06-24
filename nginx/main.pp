class { 'nginx': }
file { "/etc/nginx/sites-enabled/hostng.conf":
  ensure => "present",
  owner => "root",
  group => "root",
  mode =>  "0764",
  source => "/tmp/hostng.conf",
  notify  => Service['nginx'],
}
file { "/etc/nginx/conf.d/default.conf":
  ensure => "present",
  owner => "root",
  group => "root",
  mode =>  "0764",
  source => "/tmp/proxy.conf",
  notify  => Service['nginx'],
 }
file { "/etc/nginx/backendservers.list":
  ensure => "present",
  owner => "root",
  group => "root",
  mode =>  "0764",
  source => "/tmp/backendservers.list",
  notify  => Service['nginx'],
}
