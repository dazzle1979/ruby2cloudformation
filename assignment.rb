# frozen_string_literal: true

require 'json'
require './cmdparser'
require './cfcompiler'
require 'aws-sdk'

# init client for cloudformation
cf_client = Aws::CloudFormation::Client.new(region: 'eu-central-1')
# set output directory
output_dir = Dir.getwd + '/output'

# do the optionparser
options = CmdParser.parse(ARGV)
# use the options to generate the cf template
json = CfCompiler.compile(options)

# do output, if in console, else create file in /output
if options[:file_output] == ''
  puts JSON.pretty_generate(json)
else
  Dir.mkdir output_dir unless File.directory?(output_dir)
  File.write(
    output_dir + '/' + options[:file_output], JSON.pretty_generate(json)
  )
end

# TODO: verplaatsen naar aparte class?!
def check_stack(cf_client, stack_name)
  resp_describe = cf_client.describe_stacks(
    stack_name: stack_name
  )
  if resp_describe.stacks[0].stack_status != 'CREATE_IN_PROGRESS'
    if resp_describe.stacks[0].stack_status == 'CREATE_COMPLETE'
      puts 'Stack creation successful, PublicIP:'
      puts resp_describe.stacks[0].outputs[0].output_value
    else
      puts 'Stack creation failed with status:'
      puts resp_describe.stacks[0].stack_status
    end
    return false
  else
    puts resp_describe.stacks[0].stack_status
    return true
  end
end

# validate JSON with AWS and create stack if create_stack is true
if options[:create_stack].to_s == 'true'
  resp_validate = cf_client.validate_template(template_body: json.to_json)
  if resp_validate.successful?
    puts 'Cloudformation JSON valid, creating stack:'
    cf_client.create_stack(
      stack_name: options[:stack_name],
      template_body: json.to_json
    )
    sleep 2 while check_stack(cf_client, options[:stack_name])
  elsif !resp_validate.successful?
    puts 'Cloudformation JSON template invalid'
  end
end
