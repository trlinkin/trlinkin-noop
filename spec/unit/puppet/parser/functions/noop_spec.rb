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

    expect(catalog.resource('File[/tmp/foo]')[:noop]).to eq(true)

  end
  
  it "should give every resource a default of 'noop => false when arg0 is false'" do
    Puppet[:code] = <<-NOOPCODE
      noop(false)
      file {'/tmp/foo':}
    NOOPCODE

    catalog = scope.compiler.compile

    expect(catalog.resource('File[/tmp/foo]')[:noop]).to eq(false)
  end

  it "should give every resource a default of 'noop => true' when arg0 is true" do
    Puppet[:code] = <<-NOOPCODE
      class test {
        file { '/tmp/foo':}
      }
      include test
      noop(true)
    NOOPCODE

    catalog = scope.compiler.compile

    expect(catalog.resource('File[/tmp/foo]')[:noop]).to eq(true)
  end
  
  it "should give every resource a default of 'noop => true' when arg0 is non-bool" do
    Puppet[:code] = <<-NOOPCODE
      class test {
        file { '/tmp/foo':}
      }
      include test
      noop('potato')
    NOOPCODE

    catalog = scope.compiler.compile

    expect(catalog.resource('File[/tmp/foo]')[:noop]).to eq(true)
  end

end
