# Noop

[![Build Status](https://travis-ci.org/trlinkin/trlinkin-noop.png?branch=master)](https://travis-ci.org/trlinkin/trlinkin-noop)

A Puppet DSL `noop()` function for setting a whole scope to noop.

## Usage

This is a statement function that accepts zero or one arguments. It can be called at any
scope. Its effects will propagate into child scopes.

```puppet
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
```

The outcome of the usage in the example above will be equivalent to setting
`noop => true` as a default for each resource. None of the resources in
`Class['ssh']` will be enforced.

For granular control, noop(false) will 'reset' the default inhereted noop value


## License

   Copyright 2012 Thomas Linkin <tom@puppetlabs.com>

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
