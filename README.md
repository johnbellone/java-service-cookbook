# java-service-cookbook
[Library cookbook][0] which provides resources for configuring a Java
service.

## Basic Usage

### Enabling and Starting a Java Service
```ruby
java_service 'host-info' do
  service_options()
  artifact_version '0.2.0-SNAPSHOT'
  artifact_group_id 'com.bloomberg.inf'
end
```

## Advanced Usage

[0]: http://blog.vialstudios.com/the-environment-cookbook-pattern
