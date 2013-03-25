fs            = require 'fs'
{print}       = require 'util'
{spawn, exec} = require 'child_process'

runCommand = (command, options) ->
  proc = spawn command, options
  proc.stdout.on 'data', (data) -> print data.toString()
  proc.stderr.on 'data', (data) -> print data.toString()
  proc.on 'exit', (status) -> callback?() if status is 0

task 'temp', 'Prototyping not so well known functions, apis etc.', ->
  options = ['utils/temp.coffee']
  runCommand 'coffee', options

task 'test', 'Test features using jasmine-node', ->
  options = ['--compilers', 'coffee:coffee-script', '-R', 'list', '-w', '-c', 'test']
  runCommand 'mocha', options

task 'run', 'Run the web application using node-supervisor', ->
  options = ['app.coffee']
  runCommand 'coffee', options
