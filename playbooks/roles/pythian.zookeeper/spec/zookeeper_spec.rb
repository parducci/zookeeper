require 'spec_helper'

describe 'Running serverspec tests for pythian.zookeeper role' do

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if zookeeper is installed' do

      describe group(resolve_ansible_variables(property['zk_group'])) do
        it { should exist }
      end

      describe user(resolve_ansible_variables(property['zk_user'])) do
        it { should exist }
        it { should belong_to_group resolve_ansible_variables(property['zk_group']) }
        it { should have_home_directory resolve_ansible_variables(property['zk_home_dir']) }
      end

      describe file(resolve_ansible_variables(property['zk_install_dir'])) do
        it { should be_directory }
        it { should be_owned_by resolve_ansible_variables(property['zk_user'])}
        it { should be_grouped_into resolve_ansible_variables(property['zk_group']) }
        it { should be_mode 755 }
      end

      describe file(resolve_ansible_variables(property['zk_conf_dir'])) do
        it { should be_directory }
        it { should be_owned_by resolve_ansible_variables(property['zk_user'])}
        it { should be_grouped_into resolve_ansible_variables(property['zk_group']) }
        it { should be_mode 755 }
      end

      describe file(resolve_ansible_variables(property['zk_data_dir'])) do
        it { should be_directory }
        it { should be_owned_by resolve_ansible_variables(property['zk_user'])}
        it { should be_grouped_into resolve_ansible_variables(property['zk_group']) }
        it { should be_mode 755 }
      end

      describe file(resolve_ansible_variables(property['zk_log_dir'])) do
        it { should be_directory }
        it { should be_owned_by resolve_ansible_variables(property['zk_user'])}
        it { should be_grouped_into resolve_ansible_variables(property['zk_group']) }
        it { should be_mode 755 }
      end

      describe file(resolve_ansible_variables(property['zk_logging_dir'])) do
        it { should be_directory }
        it { should be_owned_by resolve_ansible_variables(property['zk_user'])}
        it { should be_grouped_into resolve_ansible_variables(property['zk_group']) }
        it { should be_mode 755 }
      end

      describe file('/etc/systemd/system/zookeeper.service') do
        it { should be_file }
        it { should be_owned_by "root"}
        it { should be_grouped_into "root" }
        it { should be_mode 644 }
      end

    end

  end

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if zookeeper is configured' do

      describe file(resolve_ansible_variables(property['zk_install_dir']) + "/current") do
        it { should be_symlink }
      end

      describe file(resolve_ansible_variables(property['zk_data_dir']) + "/myid") do
        it { should be_file }
        it { should be_owned_by resolve_ansible_variables(property['zk_user'])}
        it { should be_grouped_into resolve_ansible_variables(property['zk_group'])}
        it { should be_mode 644 }
      end

      describe file(resolve_ansible_variables(property['zk_conf_dir']) + "/zookeeper.conf") do
        it { should be_file }
        it { should be_owned_by resolve_ansible_variables(property['zk_user'])}
        it { should be_grouped_into resolve_ansible_variables(property['zk_group'])}
        it { should be_mode 644 }
      end

      describe file(resolve_ansible_variables(property['zk_install_dir']) + "/current/conf/log4j.properties") do
        it { should be_file }
        it { should be_owned_by resolve_ansible_variables(property['zk_user'])}
        it { should be_grouped_into resolve_ansible_variables(property['zk_group'])}
        it { should be_mode 644 }
      end

    end

  end

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if zookeeper service is running' do

      describe service('zookeeper.service') do
        it { should be_enabled }
        it { should be_running }
      end

      describe port(resolve_ansible_variables(property['zk_port'])) do
        it { should be_listening }
      end

    end

  end

end
