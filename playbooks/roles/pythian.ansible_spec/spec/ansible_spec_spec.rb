require 'spec_helper'

describe 'Running serverspec tests for pythian.ansible_spec role' do

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if ansible_spec is installed' do

      ['gcc', 'make', 'libffi-dev'].each do |p|
        describe package(p) do
          it { should be_installed }
        end
      end

      describe package('ansible_spec') do
        it { should be_installed.by('gem') }
        it { should be_installed.by('gem').with_version(property['ansible_spec_version']) }
      end

    end

  end

end
