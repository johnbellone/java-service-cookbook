# java-service-cookbook
[Library cookbook][0] which provides resources for configuring a Java
service.

This library cookbook provides primitives to make it simple to deploy
Java services. Using the *java_service* resource configuration is fast
and simple; the best part is that it works with the native service
management of the operating system!

## Basic Usage
THe whole point of this cookbook is to provide a dead simple way to
deploy Java services to an instance. The first resource installs and
configures a Java service as a system service. This has an advantage
of being portable based on the operating systme. The second resource
allows for easy management of the
[Java properties configuration format][1].
### Enabling and Starting a Java Service
```ruby
java_service 'host-info' do
  artifact_version '0.2.0-SNAPSHOT'
  artifact_group_id 'com.bloomberg.inf'
end
```

[0]: http://blog.vialstudios.com/the-environment-cookbook-pattern
[1]: https://en.wikipedia.org/wiki/.properties
