property :name, String, name_property: true
property :type, String, required: true
property :parameters, Hash, default: {}
property :filter_name, String

default_action :config

action :config do
  filter_name = new_resource.filter_name || new_resource.name

  td_agent_filter "#{new_resource.name}" do
    filter_name "filter-#{filter_name}"
    type new_resource.type
    tag new_resource.name
    parameters new_resource.parameters
    action :create
  end
end
