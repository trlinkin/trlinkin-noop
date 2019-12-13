Puppet::Functions.create_function(:noop, Puppet::Functions::InternalFunction) do
  dispatch :noop do
    scope_param
    optional_param 'Boolean', :value
  end

  def noop(scope, value = true)
    case value
    when true
      def scope.noop_default
        true
      end
    when false
      def scope.noop_default
        false
      end
    end

    def scope.lookupdefaults(type)
      values = super(type)

      # Create a new :noop parameter with the specified value (true/false) for our defaults hash
      noop = Puppet::Parser::Resource::Param.new(
        name: :noop,
        value: noop_default,
        source: source,
      )

      # Adding this default fixes a corner case with resource collectors
      @defaults[type][:noop] = noop

      # Replace whatever defaults we recieved
      values[:noop] = noop
      values
    end
  end
end
