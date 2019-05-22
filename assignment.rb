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
puts JSON.pretty_generate(json)
resp = cf_client.validate_template({template_body: json.to_json})

#if File.directory?(options[:file_output])
  puts Dir.getwd
  File.open(Dir.getwd+'\bas.json', 'wb') { |file| file.write(json.to_json) }
  #File.write(options[:file_output], json.to_json)
#end

if options[:create_stack].to_s == 'true' && resp.successful? 
  puts "successful"
  resp = cf_client.create_stack({stack_name: options[:stack_name],template_body: json.to_json})
  puts resp.stack_id
end
