property :name, String, name_property: true
property :type, String, required: true
property :parameters, Hash, default: {}

default_action :config

action :config do
  td_agent_match "match-#{new_resource.name}" do
    type new_resource.type
    tag new_resource.name
    parameters new_resource.parameters
    action :create
  end
end
