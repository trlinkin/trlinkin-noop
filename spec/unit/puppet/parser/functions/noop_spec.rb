#! /usr/bin/env/ruby -S rspec

require 'spec_helper'

describe Puppet::Parser::Functions.function(:noop) do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "requires no arguments to compile" do
    Puppet[:code] = 'noop()'
    scope.compiler.compile
  end

  it "should give every resource a default of 'noop => true'" do
    Puppet[:code] = <<-NOOPCODE
      noop()
      file {'/tmp/foo':}
    NOOPCODE

    catalog = scope.compiler.compile

    expect { catalog.resource('File[/tmp/foo]')[:noop] }.to be_true
  end

  it "should give every resource in child scopes a default of 'noop => true'" do
    Puppet[:code] = <<-NOOPCODE
      class test {
        file { '/tmp/test_class':}
      }
      include test
      noop()
    NOOPCODE

    catalog = scope.compiler.compile

    expect { catalog.resource('File[/tmp/test_class]')[:noop] }.to be_true
  end
end
