require 'spec_helper'

describe 'Running serverspec tests for openjdk_java role' do

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if Open JDK is installed' do

      describe command("java -version") do
        its(:exit_status) { should eq 0 }
      end

    end

  end

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if openjdk_java is configured' do

      describe file('/usr/bin/java') do
        it { should be_symlink }
        it { should be_linked_to "/etc/alternatives/java" }
      end

    end

  end

end
