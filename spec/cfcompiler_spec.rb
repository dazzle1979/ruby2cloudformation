# frozen_string_literal: true

require './cfcompiler.rb'

describe 'cfcompiler' do
  it 'check output #1' do
    options = {
      instances: 1,
      instance_type: 't2.micro',
      allow_ssh_from: '0.0.0.0/0'
    }
    json = CfCompiler.compile(options)
    template = json.to_json
    parsed_template = JSON.parse(template)
    expect(parsed_template['AWSTemplateFormatVersion']).to eql('2010-09-09')
    expect(template).to include('0.0.0.0/0')
    expect(template).to include('t2.micro')
    expect(parsed_template).to have_key('Outputs')
    if parsed_template.key?('Outputs')
      expect(parsed_template['Outputs']).to have_key('PublicIP')
    end
    expect(parsed_template).to have_key('Resources')
    if parsed_template.key?('Resources')
      expect(parsed_template['Resources']).to have_key('EC2Instance')
      expect(parsed_template['Resources']).to have_key('InstanceSecurityGroup')
    end
  end
  it 'check output #2' do
    options = {
      instances: 2,
      instance_type: 't2.small',
      allow_ssh_from: '37.17.210.74/32'
    }
    json = CfCompiler.compile(options)
    template = json.to_json
    parsed_template = JSON.parse(template)
    expect(parsed_template['AWSTemplateFormatVersion']).to eql('2010-09-09')
    expect(template).to include('37.17.210.74/32')
    expect(template).to include('t2.small')
    expect(parsed_template).to have_key('Outputs')
    if parsed_template.key?('Outputs')
      expect(parsed_template['Outputs']).to have_key('PublicIP')
    end
    expect(parsed_template).to have_key('Resources')
    if parsed_template.key?('Resources')
      expect(parsed_template['Resources']).to have_key('EC2Instance')
      expect(parsed_template['Resources']).to have_key('EC2Instance2')
      expect(parsed_template['Resources']).to have_key('InstanceSecurityGroup')
    end
  end
end
