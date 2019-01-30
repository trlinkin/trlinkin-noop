# Noop

[![Build Status](https://travis-ci.org/trlinkin/trlinkin-noop.png?branch=master)](https://travis-ci.org/trlinkin/trlinkin-noop)

A Puppet DSL `noop()` function for setting a whole scope to noop.

## Compatibility Notice
Versions of the module above 1.0.0 utilize the ["modern" Puppet Function Ruby API](https://puppet.com/docs/puppet/latest/functions_ruby_overview.html) and thus
will not work on older versions of Puppet. Time to really explore upgrading from Puppet 3 I guess :)

## Usage

This is a statement function that accepts one optional Boolean argument. It can be called at any
scope. Its effects will propagate into child scopes.

```puppet
class ssh {

  noop()
  include ssh::client

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

class ssh::client {
  noop(false)

  file { '/etc/ssh/ssh_config':
    ensure => file,
  }
}
```

In the above example, none of the resources in `Class['ssh']` will be enforced
but the resources in Class['ssh::client'] *WILL* be enforced because the
default noop value is reset to false in the child's scope. Without `noop(false)`
in `Class['ssh::client']`, the parent scope's default noop value (as set with the `noop()`
function) would be inherited.

## Class interface

A convenience function is provided to implement a pattern for controlling noop
at the class level. Here's how it works:

```puppet
# This class demonstrates a standard interface for controlling noop behavior.
# The standard interface consists of two class parameters:
#
#   $class_noop:
#   Required interface parameter. Ensure resources in this class are not
#   enforced even when the Puppet agent is run in enforcement mode. This
#   parameter can be used to "turn off" a class. This parameter may be
#   combined with the noop::true_unless_no_noop() function as its default
#   value so that classes may default to enforcement=off, but can be easily
#   enforced on-demand during a one-time Puppet run using
#   `puppet agent -t --no-noop`.
#
#   $class_noop_override:
#   Optional interface parameter. Ensure resources in this class use the
#   provided noop value regardless of either the $class_noop value OR the
#   agent-level noop value. This parameter can be used to "turn on" a class,
#   even for agents running in noop mode.
#
class example::annotated (
  Boolean           $class_noop          = noop::true_unless_no_noop(), #required
  Optional[Boolean] $class_noop_override = undef, #optional
) {
  noop::class_interface()
  # WARNING: this class should now be considered a "leaf" class. Do not call
  # `include` or similar functions from this point forward without careful
  # consideration of how these scope defaults will propagate. Doing so may
  # cause unexpected side effects!
  #
  #     https://puppet.com/docs/puppet/5.3/lang_scope.html
  #     https://puppet.com/docs/puppet/5.3/lang_defaults.html

  # The noop metaparameter default is set automatically based on scope
  # defaults invoked by the noop::class_interface() function call above, which
  # in turn is determined by the $class_noop parameter, and/or the
  # $class_noop_override parameter. The explicit equivalent has been mocked in
  # as a comment, for illustration.
  file { '/tmp/annotated.txt':
    ensure  => file,
    content => "Content from example::annotated\n",
    # noop    => $value_determined_by_interface_parameters,
  }

}
```

```puppet
class profile::unannotated (
  Boolean           $class_noop = noop::true_unless_no_noop(),
  Optional[Boolean] $class_noop_override = undef,
) {
  noop::class_interface()

  file { '/tmp/unannotated.txt':
    ensure  => file,
    content => "Content from example::unannotated\n",
  }

}
```


## License

   Copyright 2012 Thomas Linkin <tom@puppet.com>

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
