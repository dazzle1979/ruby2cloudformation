# frozen_string_literal: true

require 'cfndsl'

# Use cfndsl to create Cloudformation JSON
class CfCompiler
  def self.compile(options)
    json = CloudFormation do
      Output('PublicIP') do
        Description 'Public IP address of the newly created EC2 instance'
        Value FnGetAtt('EC2Instance', 'PublicIp')
      end
      # loop instances
      options[:instances].times do |i|
        number = i.zero? ? '' : (i + 1)
        name = 'EC2Instance' + number.to_s
        EC2_Instance(name) do
          ImageId options[:image_id]
          InstanceType options[:instance_type]
          SecurityGroups [Ref('InstanceSecurityGroup')]
        end
      end
      Resource('InstanceSecurityGroup') do
        Property(
          'GroupDescription',
          'Enable SSH access and HTTP access on the inbound port'
        )
        if options[:public] == 'true'
          Property(
            'SecurityGroupIngress',
            [
              {
                'CidrIp' => options[:allow_ssh_from],
                'FromPort' => '22',
                'IpProtocol' => 'tcp',
                'ToPort' => '22'
              },
              {
                'CidrIp' => '0.0.0.0/0',
                'FromPort' => '80',
                'IpProtocol' => 'tcp',
                'ToPort' => '80'
              }
            ]
          )
        else
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
        end
        Type 'AWS::EC2::SecurityGroup'
      end
    end
    json
  end
end
