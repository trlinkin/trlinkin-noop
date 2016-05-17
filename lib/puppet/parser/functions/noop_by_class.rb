# Set noop to true as default for current and children scopes
Puppet::Parser::Functions::newfunction(:noop_by_class, :doc => "Set noop default to true for all resources
  in local scope and children scopes. This can be overriden in
  child scopes, or explicitly on each resource.
  ") do |arguments|

  raise(Puppet::ParseError, 'noop_by_class(): requires at least one argument') if arguments.length == 0

  classes = arguments.flatten

  classes.each do |arg|
    if not arg.is_a?(String)
      raise(Puppet::ParseError, 'noop(): arguments must be strings')
    end
  end


  # Attempt to "noop" scopes already known
  classes.reject! do |klass|
    known_klass = find_hostclass(klass)
    if known_klass && klass_scope = class_scope(known_klass)
      klass_scope.call_function(:noop,[])
      true
    else
      false
    end
  end


  # If there are scopes we don't know yet, try to set up to "noop" them when they appear
  topscope = find_global_scope

  if patch_list = topscope.instance_variable_get(:@_noop_patched)
    # We already have patched the topscope metaclass, lets just add some class names to the list
    patch_list = (patch_list + classes).uniq
    topscope.instance_variable_set(:@_noop_patched, patch_list)
  else
    topscope.instance_variable_set(:@_noop_patched, classes)

    (class << topscope; self; end).class_eval do
      old_lookupdefaults = instance_method(:lookupdefaults)

      define_method(:lookupdefaults) do |type|
        # For the classes passed as arguments, we will find their scopes and override their lookupdefaults methods
        #classes = self.instance_variable_get(:@_noop_patched)
        classes = @_noop_patched

        classes.each do |klass|
          puppet_klass = find_hostclass(klass)
          if puppet_klass && victim_scope = class_scope(puppet_klass)
            victim_scope.call_function(:noop,[])
            @_noop_patched.delete(klass)
          end
        end

        # Resume our original lookupdefaults method, already in progress
        values = old_lookupdefaults.bind(self).(type)
        values
      end
    end
  end
end

