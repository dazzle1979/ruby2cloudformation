# frozen_string_literal: true

require 'json'
require './cmdparser'
require './cfcompiler'
require './cfstack'

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
  File.write(
    output_dir + '/' + options[:file_output], JSON.pretty_generate(json)
  )
end

# validate JSON with AWS and create stack if create_stack is true
if options[:create_stack].to_s == 'true'
  cfstack = CfStack.new(options[:stack_name], json, 'eu-central-1')
  cfstack.create
end
