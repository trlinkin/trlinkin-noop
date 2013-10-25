# Set noop to true as default for current and children scopes
Puppet::Parser::Functions::newfunction(:noop, :doc => "Set noop default to true for all resources
  in local scope and children scopes. This can be overriden in
  child scopes, or explicitly on each resource.
  ") do |args|

  class << self
    def lookupdefaults(type)
      values = super(type)

      # Create a new :noop paramter with value of true for our defaults hash
      noop = Puppet::Parser::Resource::Param.new(
        :name => :noop, :value => 'true', :source => self.source )

      # Replace whatever defaults we recieved
      values[:noop] = noop
      values
    end
  end
end
