require 'spec_helper'

describe 'Running serverspec tests for pythian.oracle_java role' do

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if Oracle JDK is installed' do

      describe command("java -version") do
        its(:exit_status) { should eq 0 }
      end

      describe command('java -version 2>&1') do
        its(:exit_status) { should eq 0 }
        its(:stdout) { should match /1\.#{property['java_version']}\.0_#{property['java_subversion']}/ }
      end

    end

    describe 'Test if Oracle JCE is installed' do

      describe command("$(dirname $(dirname $(readlink -e $(which java))))/bin/jrunscript -e 'print (javax.crypto.Cipher.getMaxAllowedKeyLength(\"RC5\") >= 256);'") do
        its(:exit_status) { should eq 0 }
      end

    end

  end

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if oracle_java is configured' do

      describe file('/usr/bin/java') do
        it { should be_symlink }
        it { should be_linked_to "/etc/alternatives/java" }
      end

      describe file('/etc/alternatives/java') do
        it { should be_symlink }
        it { should be_linked_to "#{property['java_install_dir']}/#{property['java_default_link_name']}/bin/java" }
      end

      describe file('/usr/bin/javac') do
        it { should be_symlink }
        it { should be_linked_to "/etc/alternatives/javac" }
      end

      describe file('/etc/alternatives/javac') do
        it { should be_symlink }
        it { should be_linked_to "#{property['java_install_dir']}/#{property['java_default_link_name']}/bin/javac" }
      end

      describe file('/usr/bin/jar') do
        it { should be_symlink }
        it { should be_linked_to "/etc/alternatives/jar" }
      end

      describe file('/etc/alternatives/jar') do
        it { should be_symlink }
        it { should be_linked_to "#{property['java_install_dir']}/#{property['java_default_link_name']}/bin/jar" }
      end

      describe file('/usr/lib/jvm/java') do
        it { should be_symlink }
        it { should be_linked_to "/etc/alternatives/java_sdk" }
      end

      describe file('/etc/alternatives/java_sdk') do
        it { should be_symlink }
        it { should be_linked_to "#{property['java_install_dir']}/#{property['java_default_link_name']}" }
      end

    end

  end

end
