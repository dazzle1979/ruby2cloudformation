require 'ipaddress'
require 'optparse'

class CmdParser
    def self.parse(args)
      options = {
        instances: 1,
        instance_type: 't2.micro',
        allow_ssh_from: '0.0.0.0/0',
        image_id: 'ami-b97a12ce',
        create_stack: 'false',
        stack_name: 'bas_stack',
        file_output: ''
      }
      parser = OptionParser.new do |parser|
        parser.banner = 'Usage: assignment.rb [options]'
        parser.on(
          '--instances NUMBER',
          'The number of instances.'
        ) do |v|
          options[:instances] = v.to_i
        end
        parser.on(
          '--instance-type NAME',
          'The name of the instance type.'
        ) do |v|
          options[:instance_type] = v
        end
        parser.on(
          '--allow-ssh-from IP',
          'The ipaddress to allow ssh access'
        ) do |v|
          host = IPAddress::IPv4.new v
          options[:allow_ssh_from] = host.to_string
        end
        parser.on(
          '--image-id AMI ID',
          'The ID of the AMI'
        ) do |v|
          options[:image_id] = v
        end
        parser.on(
          '--create-stack BOOLEAN',
          'Should the stack be created'
        ) do |v|
          options[:create_stack] = v
        end
        parser.on(
          '--stack-name NAME',
          'Create the stack with this name'
        ) do |v|
          options[:stack_name] = v
        end
        parser.on(
          '--file-output PATH',
          'Store Cloudformation template on disk'
        ) do |v|
          options[:file_output] = v
        end
      end
      begin
        parser.parse(args)
      rescue Exception => e
        puts e
        exit 1
      end
  
      options
    end
  end