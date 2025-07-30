# barito-agent-cookbook

A Chef cookbook for setting up Barito Agent on server nodes.

## Overview

This cookbook automates the installation and configuration of Barito Agent, which collects logs from various sources and forwards them to your Barito logging infrastructure.

## Features

- **Automated Agent Setup**: Installs and configures td-agent (Fluentd)
- **Flexible Log Sources**: Support for file, systemd, and other log sources
- **systemd Integration**: Built-in support for systemd journal logs
- **Configurable Output**: Easy configuration for Barito endpoints

## Requirements

### Platforms

- Ubuntu 16.04+
- CentOS 7+
- RHEL 7+

### Chef

- Chef 14.0+

## Usage

### Basic Setup

Include the cookbook in your runlist:

```ruby
include_recipe 'barito-agent-cookbook'
```

### Configuration

Configure log sources in your node attributes:

```ruby
default['barito-agent-cookbook']['sources'] = [
  {
    type: 'tail',
    name: 'application-logs',
    path: '/var/log/myapp/*.log',
    format: 'json'
  }
]
```

### systemd Journal Integration

Example configuration for collecting systemd journal logs:

```ruby
default['barito-agent-cookbook']['sources'] = [
  {
    type: 'systemd',
    name: 'barito-journalctl',
    path: '/run/log/journal',
    raw_options: ['matches'],
    matches: [{'_SYSTEMD_UNIT': 'syslog.service'}],
    read_from_head: true,
    storage: {
      '@type': 'local',
      persistent: true,
      path: '/etc/td-agent/barito-journalctl.pos'
    },
    entry: {
      fields_strip_underscores: true,
      fields_lowercase: true
    }
  }
]
```

### Output Configuration

Configure Barito output:

```ruby
default['barito-agent-cookbook']['output'] = {
  type: 'barito_vm',
  application_secret: 'your-app-secret',
  produce_url: 'https://your-barito-router/produce'
}
```

## Attributes

| Attribute | Description | Default |
|-----------|-------------|---------|
| `['barito-agent-cookbook']['sources']` | Array of log source configurations | `[]` |
| `['barito-agent-cookbook']['output']` | Output configuration for Barito | `{}` |
| `['barito-agent-cookbook']['agent_user']` | User to run td-agent as | `'td-agent'` |
| `['barito-agent-cookbook']['agent_group']` | Group for td-agent | `'td-agent'` |

## Log Source Types

### File Tailing

```ruby
{
  type: 'tail',
  name: 'access-logs',
  path: '/var/log/nginx/access.log',
  format: 'nginx'
}
```

### systemd Journal

```ruby
{
  type: 'systemd',
  name: 'system-logs',
  path: '/run/log/journal',
  matches: [{'_SYSTEMD_UNIT': 'nginx.service'}]
}
```

### Syslog

```ruby
{
  type: 'syslog',
  name: 'syslog',
  port: 5140,
  bind: '0.0.0.0'
}
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

Licensed under the Apache License, Version 2.0.
