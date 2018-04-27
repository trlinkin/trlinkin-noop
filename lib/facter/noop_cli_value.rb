Facter.add(:noop_cli_value) do
  setcode do
    # This will be nil if Puppet is not available.
    begin
      Module.const_get('Puppet')
    rescue NameError
      nil
    else
      # if set on the cli, the boolean value. Otherwise undef.
      if Puppet.settings.set_by_cli?(:noop)
        Puppet.settings[:noop]
      else
        nil
      end
    end
  end
end
