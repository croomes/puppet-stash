class stash::user{

  group { "$stash::params::group":
    ensure  => present,
    gid     => "$stash::params::gid",
  }

  user { "$stash::params::user":
    ensure      => present,
    home        => "$stash::params::user_home",
    managehome  => true,
    password    => "$stash::params::user_password",
    gid         => "$stash::params::gid",
    comment     => "Stash Service User",
    uid         => "$stash::params::uid",
  }
}
