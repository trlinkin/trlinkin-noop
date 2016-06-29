require 'puppetclassify'
# Set noop to true as default for current and children scopes
Puppet::Parser::Functions::newfunction(
  :noop_from_console,
  :doc => "Set noop default to true for all resources
  in local scope and children scopes. This can be overriden in
  child scopes, or explicitly on each resource."
  ) do |args|

  group_vars = args

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
    content["variables"].each do |var|
      if group_vars.include? var
        call_function(:noop_by_class,content['classes'].keys)
      end
    end
  end

end
