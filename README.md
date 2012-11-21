Noop
====

A Puppet DSL `noop` function for setting a whole scope to noop.

Usage
-----
This function takes no arguments and returns nothing. It can be called at any scope.
	
	Class ssh {
	
	  noop()
	  
	  package { 'openssh-server' :
	    ensure => installed,
	  }
	  
	  service { 'sshd':
	    ensure  => running,
	    require => Package['openssh-server'],
	  }
	}
	
The above example will set the equvilant of `noop => true` on each resource. None of this resources in the `ssh class` will be enforced.
