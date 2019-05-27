# frozen_string_literal: true

require 'aws-sdk'

# Stack creation: Validate -> Create -> Check
class CfStack
  def initialize(name, json, region)
    @name = name
    @json = json
    @cf_client = Aws::CloudFormation::Client.new(region: region)
  end

  def create
    resp_validate = @cf_client.validate_template(template_body: @json.to_json)
    if resp_validate.successful?
      puts 'Cloudformation JSON valid, creating stack:'
      @cf_client.create_stack(
        stack_name: @name,
        template_body: @json.to_json
      )
      sleep 2 while check
    elsif !resp_validate.successful?
      puts 'Cloudformation JSON template invalid'
    end
  end

  def check
    resp_describe = @cf_client.describe_stacks(
      stack_name: @name
    )
    status = resp_describe.stacks[0].stack_status
    if status != 'CREATE_IN_PROGRESS'
      if status == 'CREATE_COMPLETE'
        puts 'Stack creation successful, PublicIP:'
        puts resp_describe.stacks[0].outputs[0].output_value
      else
        puts 'Stack creation failed with status:'
        puts status
      end
      return false
    else
      puts status
      return true
    end
  end
end
