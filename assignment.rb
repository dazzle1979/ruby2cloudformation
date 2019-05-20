
require "cfndsl" 
require "json"

json = (CloudFormation {

    Output("PublicIP") do
        Description "Public IP address of the newly created EC2 instance"
        Value FnGetAtt("EC2Instance","PublicIp")
    end
  
    EC2_Instance(:EC2Instance) {
      ImageId "ami-b97a12ce"
      InstanceType "t2.micro"
      SecurityGroups [Ref("InstanceSecurityGroup")]
    }
    Resource("InstanceSecurityGroup") do
        Property("GroupDescription", "Enable SSH access and HTTP access on the inbound port")
        Property("SecurityGroupIngress",
                 [
                   {
                    "CidrIp" => "0.0.0.0/0",
                    "FromPort" => "22",
                    "IpProtocol" => "tcp",
                    "ToPort" => "22"
                   }
                 ])
        Type "AWS::EC2::SecurityGroup"
    end
  })
  puts JSON.pretty_generate(json)