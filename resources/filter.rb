property :name, String, name_property: true
property :type, String, required: true
property :parameters, Hash, default: {}

default_action :config

action :config do
  td_agent_filter "#{new_resource.name}" do
    filter_name "filter-#{new_resource.name}"
    type new_resource.type
    tag new_resource.name
    parameters new_resource.parameters
    action :create
  end
end
