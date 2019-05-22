require 'cfndsl'

class CfCompiler
  def self.compile (options) 
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
    json
  end
end