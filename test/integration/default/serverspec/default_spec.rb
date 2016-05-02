require 'serverspec'
set :backend, :exec

unless os[:family] == 'windows'
  describe file('/opt/maven/3.3.9') do
    it { should exist }
    it { should be_directory }
  end

  describe file('/usr/local/bin/mvn') do
    it { should exist }
    it { should be_file }
    it { should be_symlink }
    it { should be_linked_to '/opt/maven/3.3.9/bin/mvn' }
  end

  describe file('/etc/mavenrc') do
    it { should exist }
    it { should be_file }
    it { should contain %r{M2_HOME="/opt/maven/3.3.9"} }
  end
end
