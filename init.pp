Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

exec { 'yum update':
  command => 'yum update',
  refreshonly => true,
}

package {[ 'vim', 'tmux', 'ack', 'tree']:
  ensure => installed,
  require => Exec['yum update'],
}

# TODO get user home direcory dynamic
file { '/home/vagrant/.vimrc':
  ensure => present,
  owner => 'vagrant',
  group => 'vagrant',
  mode => '0755',
  content => template('vimrc.erb'),
}

file { '/home/vagrant/bundle':
  ensure => directory,
  owner => 'vagrant',
  group => 'vagrant',
  mode => '0755',
}

$neovundle_url = 'git://github.com/Shougo/neobundle.vim '

exec { "git clone ${neovundle_url} /home/vagrant/.vim/bundle/neovundle.vim":
  unless => "test -e /home/vagrant/vundle/neovundle.vim"
}

#vcsrepo { "neovundle":
#  ensure => latest,
#  provider => git,
#  require => File['/home/vagrant/bundle'],
#  source => $neovundle_url,
#  user => 'vagrant',
#}

file { '/home/vagrant/.tmux.conf':
  ensure => present,
  owner => 'vagrant',
  group => 'vagrant',
  mode => '0755',
  content => template('tmux.conf.erb'),
}

file { '/home/vagrant/.gitconfig':
  ensure => present,
  owner => 'vagrant',
  group => 'vagrant',
  mode => '0755',
  content => template('gitconfig.erb'),
}
