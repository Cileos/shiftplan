node 'develop' {
  $username = 'vagrant'
  # rvm
  package {
    [
      'build-essential',
      'openssl',
      'libreadline6',
      'libreadline6-dev',
      'curl',
      'git-core',
      'zlib1g',
      'zlib1g-dev',
      'libssl-dev',
      'libyaml-dev',
      'libsqlite3-0',
      'libsqlite3-dev',
      'sqlite3',
      'libxml2-dev',
      'autoconf',
      'libc6-dev',
      'automake',
      'libtool',
      'bison',
      'subversion'
    ]: ensure => installed;
  }

  # app
  package {
    [
     'imagemagick',
     'libjpeg-progs',
     'libpq-dev',
     'postgresql',
     'postgresql-contrib',
     'libxslt1-dev',
     'gnupg',
     'nodejs',
     'libcurl4-openssl-dev'
    ]: ensure => installed;
  }
}
