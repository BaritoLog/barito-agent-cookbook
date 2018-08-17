# barito-agent-cookbook

Chef cookbook to setup Barito Agent on our nodes.

## Using `fluent-plugin-systemd`

Below is the examples of input configuration.

```ruby
default[cookbook_name]['sources'] = [
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

