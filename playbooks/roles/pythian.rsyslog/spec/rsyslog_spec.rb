require 'spec_helper'

describe 'Running serverspec tests for pythian.rsyslog role' do

  if ['VMLC.all', 'VMLC.rsyslog', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if rsyslog is installed' do

      describe package('rsyslog') do
        it { should be_installed }
      end

      describe command('rsyslogd -version|grep rsyslogd|awk \'{print $2}\'|sed s/,//') do
        its(:stdout) { should match /#{property['rsyslogd_version']}/ }
      end
    end

    describe 'Test if syslog service is running' do

      describe service('syslog') do
        it { should be_running }
      end
    end


  end

  if ['VMLC.all', 'VMLC.provision', 'VMLC.image_build'].include?(property['vmlc_stage'])

    describe 'Test if rsyslog is configured' do
     
        describe file('/etc/rsyslog.conf') do
          it { should be_file }
          it { should be_mode 644 }
          it { should be_owned_by 'root' }
          it { should contain('#$KLogPermitNonKernelFacility') }
        end
        
        describe file('/etc/rsyslog.d/50-default.conf') do
          it { should be_file }
          it { should be_mode 644 }
          it { should be_owned_by 'root' }
          it { should contain('#').from(/^daemon.*;mail.*;/).to(/^*\/dev\/xconsole/) }
        end
    end

  end

end
