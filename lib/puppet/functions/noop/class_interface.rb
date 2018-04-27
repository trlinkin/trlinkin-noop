Puppet::Functions.create_function(:"noop::class_interface", Puppet::Functions::InternalFunction) do
  dispatch :interface do
    scope_param
  end

  def interface(scope)
    if scope.bound?('class_noop')
      override = scope.bound?('class_noop_override') ? scope['class_noop_override'] : nil
      class_noop(scope, scope['class_noop'], override)
    else
      raise "Unable to implement noop::class_interface(). Class must define specific parameters:
  class example (
    Boolean           $class_noop = noop::true_unless_no_noop(), #required
    Optional[Boolean] $class_noop_override = undef, #optional
    ...
  ) {
    noop::class_interface()
    ...
  }
    "
    end
  end

  def class_noop(scope, class_noop, class_noop_override = nil)
    noop_default = if !class_noop_override.nil?
                     class_noop_override
                   elsif scope['facts']['clientnoop'] == false
                     class_noop
                   else
                     true
                   end

    call_function('noop', noop_default)
  end
end
