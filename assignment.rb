# frozen_string_literal: true

require 'cfndsl'
require 'json'
require 'optparse'
require 'ipaddress'

options = {
  instances: 1,
  instance_type: 't2_micro',
  allow_ssh_from: '0.0.0.0/0'
}

OptionParser.new do |parser|
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
end.parse!

json = CloudFormation do
  Output('PublicIP') do
    Description 'Public IP address of the newly created EC2 instance'
    Value FnGetAtt('EC2Instance', 'PublicIp')
  end

  options[:instances].times do |i|
    number = i.zero? ? '' : (i + 1)
    name = 'EC2Instance' + number.to_s
    EC2_Instance(name) do
      ImageId 'ami-b97a12ce'
      InstanceType options[:instance_type]
      SecurityGroups [Ref('InstanceSecurityGroup')]
    end
  end
  Resource('InstanceSecurityGroup') do
    Property(
      'GroupDescription',
      'Enable SSH access and HTTP access on the inbound port'
    )
    Property(
      'SecurityGroupIngress',
      [
        {
          'CidrIp' => options[:allow_ssh_from],
          'FromPort' => '22',
          'IpProtocol' => 'tcp',
          'ToPort' => '22'
        }
      ]
    )
    Type 'AWS::EC2::SecurityGroup'
  end
end
puts JSON.pretty_generate(json)
