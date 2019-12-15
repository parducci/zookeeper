require 'serverspec'
require 'net/ssh'
require 'ansible_spec'
require 'winrm'
require 'serverspec_extended_types'

##### Custom settings #####
# Request that a pseudo-tty (or “pty”) be made available
set :request_pty, true
###########################

##################################################################
# Helper functions
##################################################################

# Resolve Ansible variable interpolations
def resolve_ansible_variables(variables_string)
  resolved_variables_string = variables_string

  begin
    if !(resolved_variables_string.instance_of? String)
      break
    end

    variable_name_interpolation = resolved_variables_string.match(/\{\{[[:blank:]]*([a-zA-z][a-zA-Z0-9\_]*)[[:blank:]]*\}\}/)
    if !variable_name_interpolation.blank?
      variable_name = variable_name_interpolation[0].gsub(/\{\{[[:blank:]]*/,"").gsub(/[[:blank:]]*\}\}/,"")
      resolved_variables_string = "#{resolved_variables_string}".gsub(/\{\{[[:blank:]]*#{variable_name}[[:blank:]]*\}\}/,"#{property[variable_name]}")
    end
  end while !variable_name_interpolation.blank?

  return resolved_variables_string
end

# Convert a list in string form to a list type
def convert_list_in_string_form_to_list_type(list_in_string_form)
    if !(list_in_string_form.instance_of? String)
      return list_in_string_form
    end

  return list_in_string_form.gsub!(/[\[\]\'\"]/,'').split(/\s*,\s*/)
end

##################################################################

#
# Set ansible variables to serverspec property
#
host = ENV['TARGET_HOST']
hosts = ENV["TARGET_HOSTS"]

group_idx = ENV['TARGET_GROUP_INDEX'].to_i
vars = AnsibleSpec.get_variables(host, group_idx,hosts)
ssh_config_file = AnsibleSpec.get_ssh_config_file
set_property vars

connection = ENV['TARGET_CONNECTION']

if connection != 'winrm'
#
# OS type: UN*X
#
  set :backend, :ssh

  if ENV['ASK_SUDO_PASSWORD']
    begin
      require 'highline/import'
    rescue LoadError
      fail "highline is not available. Try installing it."
    end
    set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
  else
    set :sudo_password, ENV['SUDO_PASSWORD']
  end

  unless ssh_config_file
    options = Net::SSH::Config.for(host)
  else
    options = Net::SSH::Config.for(host,files=[ssh_config_file])
  end

  options[:user] ||= ENV['TARGET_USER']
  options[:port] ||= ENV['TARGET_PORT']
  options[:keys] ||= ENV['TARGET_PRIVATE_KEY']

  set :host,        options[:host_name] || host
  set :ssh_options, options

  # Disable sudo
  # set :disable_sudo, true


  # Set environment variables
  # set :env, :LANG => 'C', :LC_MESSAGES => 'C'

  # Set PATH
  # set :path, '/sbin:/usr/local/sbin:$PATH'
else
#
# OS type: Windows
#
  set :backend, :winrm
  set :os, :family => 'windows'

  user = ENV['TARGET_USER']
  port = ENV['TARGET_PORT']
  pass = ENV['TARGET_PASSWORD']

  if user.nil?
    begin
      require 'highline/import'
    rescue LoadError
      fail "highline is not available. Try installing it."
    end
    user = ask("\nEnter #{host}'s login user: ") { |q| q.echo = true }
  end
  if pass.nil?
    begin
      require 'highline/import'
    rescue LoadError
      fail "highline is not available. Try installing it."
    end
    pass = ask("\nEnter #{user}@#{host}'s login password: ") { |q| q.echo = false }
  end

  endpoint = "http://#{host}:#{port}/wsman"

  winrm = ::WinRM::WinRMWebService.new(endpoint, :ssl, :user => user, :pass => pass, :basic_auth_only => true)
  winrm.set_timeout 300 # 5 minutes max timeout for any operation
  Specinfra.configuration.winrm = winrm

end
