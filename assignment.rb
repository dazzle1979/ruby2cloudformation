# frozen_string_literal: true

require 'json'
require './cmdparser'
require './cfcompiler'
require 'aws-sdk'

cf_client = Aws::CloudFormation::Client.new(region: 'eu-central-1')

#do the optionparser
options = CmdParser.parse(ARGV)
#use the options to generate the cf template
json = CfCompiler.compile(options)
#output pretty json
#puts JSON.pretty_generate(json)
resp = cf_client.validate_template({template_body: json.to_json})

if resp.successful? 
  puts "successful"
  resp = cf_client.create_stack({stack_name: "StackName",template_body: json.to_json})
  puts resp.stack_id
end
