Dropbox = require "dropbox"
client = new Dropbox.Client key: "su10ytaxv0js1ac", secret: "la67olph2o4lk6e"

client.authDriver(new Dropbox.AuthDriver.NodeServer(4000))

client.authenticate (error, client) ->
  return showError(error)  if error
  doSomethingCool client

client.getAccountInfo (error, accountInfo) ->
  return showError(error)  if error # Something went wrong.
  alert "Hello, " + accountInfo.name + "!"

client.writeFile "hello_world.txt", "Hello, world!\n", (error, stat) ->
  return showError(error)  if error # Something went wrong.
  alert "File saved as revision " + stat.revisionTag

client.readFile "hello_world.txt", (error, data) ->
  return showError(error)  if error # Something went wrong.
  alert data # data has the file's contents

client.readdir "/", (error, entries) ->
  return showError(error)  if error # Something went wrong.
  alert "Your Dropbox contains " + entries.join(", ")

showError = (err)->
  console.log -11, err