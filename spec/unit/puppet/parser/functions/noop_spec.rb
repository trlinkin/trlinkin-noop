require 'spec_helper'

describe Puppet::Parser::Functions.function(:noop) do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "requires no arguments to compile" do
    Puppet[:code] = 'noop()'
    scope.compiler.compile
  end

  it "should give every resource a default of 'noop => true' when no argument is passed" do
    Puppet[:code] = <<-NOOPCODE
      noop()
      file {'/tmp/foo':}
    NOOPCODE

    catalog = scope.compiler.compile

    expect(catalog.resource('File[/tmp/foo]')[:noop]).to eq(true)

  end

  it "should give every resource a default of 'noop => false' when the first argument is boolean false" do
    Puppet[:code] = <<-NOOPCODE
      noop(false)
      file {'/tmp/foo':}
    NOOPCODE

    catalog = scope.compiler.compile

    expect(catalog.resource('File[/tmp/foo]')[:noop]).to eq(false)
  end

  it "should give every resource a default of 'noop => true' when the first argument is boolean true" do
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

  it "should raise an exception when first argument is not a boolean" do
    Puppet[:code] = <<-NOOPCODE
      class test {
        file { '/tmp/foo':}
      }
      include test
      noop('potato')
    NOOPCODE

    expect{scope.compiler.compile}.to raise_error(Puppet::ParseError)
  end

end
