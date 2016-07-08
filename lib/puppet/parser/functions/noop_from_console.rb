require 'puppetclassify'
# Set noop to true as default for current and children scopes
Puppet::Parser::Functions::newfunction(
  :noop_from_console,
  :doc => <<-'EOT'
    Set classes to run in "noop" mode based on classification from the
    Enterprise console.

    This function will check the classifier groups a node matches for
    classification and check to see if a specific variable is set. If the variable
    this function is told to watch for is set to any value, the classes associated
    to the classifier group will be set to run in "noop" mode using the
    "noop_by_class()" function.

    The vairable(s) to be watched for by this function can be passes as string arguments.

    If no variable names are passed, the default of variable name of "noop" is used.
    EOT
  ) do |args|

  group_vars = args
  if group_vars.count == 0
    group_vars << 'noop'
  end

  node = self.compiler.node

  terminus_config = Puppet::Node::Classifier.load_config.first

  config = {
    "ca_certificate_path" => Puppet['localcacert'],
    "certificate_path"    => Puppet['hostcert'],
    "private_key_path"    => Puppet['hostprivkey'],
  }

  client = PuppetClassify.new("https://#{terminus_config[:server]}:#{terminus_config[:port]}#{terminus_config[:prefix]}", config)

  facts = {
    "fact" => node.facts.to_data_hash['values'],
    "trusted" => node.trusted_data
  }

  group_list = client.classification.get(node.name, facts)['groups']

  group_list.each do |group|
    content = client.groups.get_group(group)
    content["variables"].keys.each do |var|
      if group_vars.include? var
        call_function(:noop_by_class,content['classes'].keys)
      end
    end
  end

end
