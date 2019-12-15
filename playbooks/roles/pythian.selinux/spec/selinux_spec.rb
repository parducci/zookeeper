require 'spec_helper'

describe 'Running serverspec tests for pythian.selinux role' do

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if selinux is installed' do

      describe package('selinux-basics') do
        it { should be_installed }
      end

      describe package('auditd') do
        it { should be_installed }
      end

      describe package('selinux-policy-default') do
        it { should be_installed }
      end

      # selinux does not persist 'enforcing' on Ubuntu
      # describe selinux do
      #   it { should be_enforcing }
      # end

    end

  end

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if selinux is configured' do

      describe file(property['selinux_conf_file']) do
        it { should be_file }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        it { should be_mode 644 }

        its(:content) { should match /SELINUX=#{property['selinux_state']}/ }
        its(:content) { should match /SELINUXTYPE=#{property['selinux_policy']}/ }
        its(:content) { should match /SETLOCALDEFS=#{property['selinux_localdefs']}/ }
      end

    end

  end

end
