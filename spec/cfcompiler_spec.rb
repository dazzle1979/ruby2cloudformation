# frozen_string_literal: true

require './cfcompiler.rb'

describe 'cfcompiler' do
  it 'check output string' do
    options = {
      instances: 1,
      instance_type: 't2.micro',
      allow_ssh_from: '0.0.0.0/0'
    }
    json = CfCompiler.compile(options)
    template = json.to_json
    parsed_template = JSON.parse(template)
    expect(parsed_template['AWSTemplateFormatVersion']).to eql('2010-09-09')
  end
end
