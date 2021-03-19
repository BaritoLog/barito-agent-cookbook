property :name, String, name_property: true
property :tag, String, name_property: true
property :type, String, required: true
property :parameters, Hash, default: {}

default_action :config

action :config do
  parameters = new_resource.parameters.select { |k, v| k != 'raw_options' }
  raw_options = new_resource.parameters['raw_options']

  td_agent_source "source-#{new_resource.name}" do
    type new_resource.type
    tag new_resource.tag
    parameters parameters
    _raw_options raw_options if raw_options
    action :create
  end
end
