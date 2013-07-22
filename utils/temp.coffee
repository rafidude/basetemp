_ = require 'underscore'

users = [
  id: 1, username: "bob", password: "secret", email: "bob@example.com"
,
  id: 2, username: "joe", password: "birthday", email: "joe@example.com"
]

findByUsername = (username, done) ->
  process.nextTick ->
    user = _.find users, (ele) ->
      ele.username = username
    done null, user

findByUsername 'joe', (err, user)->
  console.log -11, user