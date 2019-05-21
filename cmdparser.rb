require 'ipaddress'
require 'optparse'

class CmdParser
    def self.parse(args)
      options = {
        instances: 1,
        instance_type: 't2.micro',
        allow_ssh_from: '0.0.0.0/0'
      }
      parser = OptionParser.new do |parser|
        parser.banner = 'Usage: assignment.rb [options]'
        parser.on(
          '-i',
          '--instances NUMBER',
          'The number of instances.'
        ) do |v|
          options[:instances] = v.to_i
        end
        parser.on(
          '-t',
          '--instance-type NAME',
          'The name of the instance type.'
        ) do |v|
          options[:instance_type] = v
        end
        parser.on(
          '-a',
          '--allow-ssh-from IP',
          'The ipaddress to allow ssh access'
        ) do |v|
          host = IPAddress::IPv4.new v
          options[:allow_ssh_from] = host.to_string
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