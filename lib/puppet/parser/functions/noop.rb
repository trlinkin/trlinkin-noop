# Set noop to true as default for current and children scopes, or 'reset' an inherited default with noop(false)
Puppet::Parser::Functions::newfunction(:noop, :doc => "Set noop default for all resources
  in local scope and children scopes. This can be overriden in
  child scopes, or explicitly on each resource.
  ") do |args|

  if args.length > 0
    unless [true, false].include? args[0]
      raise(Puppet::ParseError, "noop(): Requires either "+
        "no arguments or a Boolean as first argument")
    end
    @noop_value = args[0] | lookupvar('clientnoop')
  else
    @noop_value = true
  end

  class << self
    def lookupdefaults(type)
      values = super(type)

      # Create a new :noop parameter with the specified value (true/false) for our defaults hash
      noop = Puppet::Parser::Resource::Param.new(
        :name => :noop, :value => @noop_value, :source => self.source )

      # Replace whatever defaults we recieved
      values[:noop] = noop
      values
    end
  end
end
