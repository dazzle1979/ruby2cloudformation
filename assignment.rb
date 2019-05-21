# frozen_string_literal: true

require 'json'
require './cmdparser'
require './cfcompiler'

#do the optionparser
options = CmdParser.parse(ARGV)
#use the options to generate the cf template
json = CfCompiler.compile(options)
#output pretty json
puts JSON.pretty_generate(json)
