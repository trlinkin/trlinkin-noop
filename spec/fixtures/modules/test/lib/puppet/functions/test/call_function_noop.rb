Puppet::Functions.create_function(:'test::call_function_noop', Puppet::Functions::InternalFunction) do
  dispatch :call_function_noop do
    scope_param
    required_param 'Enum["true","false","nil","undef"]', :argument
  end

  def call_function_noop(scope, argument)
    value = case argument
            when 'true'
              true
            when 'false'
              false
            when 'nil'
              nil
            when 'undef'
              :undef
            end

    scope.call_function('noop', value)
  end
end
