# frozen_string_literal: true

require 'ipaddress'
require 'optparse'

# Use optionparser to handle options
class CmdParser
  def self.parse(args)
    # defaults
    options = {
      instances: 1,
      instance_type: 't2.micro',
      allow_ssh_from: '0.0.0.0/0',
      image_id: 'ami-b97a12ce',
      create_stack: 'false',
      stack_name: 'bas_stack',
      file_output: '',
      public: 'false'
    }
    parser = OptionParser.new do |opts|
      opts.banner = 'Usage: assignment.rb [options]'
      opts.on(
        '--instances NUMBER',
        'The number of instances.'
      ) do |v|
        options[:instances] = v.to_i
      end
      opts.on(
        '--instance-type NAME',
        'The name of the instance type.'
      ) do |v|
        options[:instance_type] = v
      end
      opts.on(
        '--allow-ssh-from IP',
        'The ipaddress to allow ssh access'
      ) do |v|
        # use ipaddress for IP -> CIDR
        host = IPAddress::IPv4.new v
        options[:allow_ssh_from] = host.to_string
      end
      opts.on(
        '--image-id AMI ID',
        'The ID of the AMI'
      ) do |v|
        options[:image_id] = v
      end
      opts.on(
        '--create-stack BOOLEAN',
        'Should the stack be created'
      ) do |v|
        options[:create_stack] = v
      end
      opts.on(
        '--stack-name NAME',
        'Create the stack with this name'
      ) do |v|
        options[:stack_name] = v
      end
      opts.on(
        '--file-output FILENAME',
        'Store Cloudformation template on disk'
      ) do |v|
        options[:file_output] = v
      end
      opts.on(
        '--public BOOLEAN',
        'Publish on port 80 (true) '
      ) do |v|
        options[:public] = v
      end
    end
    begin
      parser.parse(args)
    rescue StandardError => e
      puts e
      exit 1
    end
    options
  end
end
