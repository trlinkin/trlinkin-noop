# Changelog

All notable changes to this project will be documented in this file.

## Release 1.1.1

**Bugfixes**

- Made `noop(undef)` callable from Ruby functions using `call_function("noop", :undef)`.

## Release 1.1.0

**Features**

- Added `noop(undef)` capability. This allows a previously defined noop default set in an outer scope to be "un-set" for an inner scope.

## Release 1.0.1

**Features**

**Bugfixes**

**Known Issues**
