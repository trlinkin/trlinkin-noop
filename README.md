Noop
====
[![Build Status](https://travis-ci.org/trlinkin/trlinkin-noop.png?branch=master)](https://travis-ci.org/trlinkin/trlinkin-noop)

A Puppet DSL `noop()` function for setting a whole scope to noop.

Usage
-----
This is a statement function that accepts no arguments. It can be called at any scope. It's effects will propagate into child scopes.

    class ssh {
	
      noop()
	  
      package { 'openssh-server' :
        ensure => installed,
      }

      file { '/etc/ssh/sshd_config':
        ensure => file,
      }
	  
      service { 'sshd':
        ensure  => running,
        require => Package['openssh-server'],
      }
    }

The outcome of the usage in the example above will be equivalent to setting `noop => true` as a default for each resource. None of the resources in Class['ssh'] will be enforced.
