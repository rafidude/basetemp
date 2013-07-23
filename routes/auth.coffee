passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
_ = require 'underscore'

users = [
  id: 1, username: "bob", password: "secret", email: "bob@example.com"
,
  id: 2, username: "joe", password: "birthday", email: "joe@example.com"
,
  id:3, username: 'tt', password: 'tt', email: 'tt@tt.tt'
]

exports.authSetup = (app) ->
  app.use passport.initialize()
  app.use passport.session()

localAuthenticate = (username, password, done) ->
  process.nextTick ->
    findByUsername username, (err, user) ->
      return done(err)  if err
      unless user
        return done(null, false,
          message: "Unknown user " + username
        )
      unless user.password is password
        return done(null, false,
          message: "Invalid password"
        )
      done null, user

passport.use new LocalStrategy(localAuthenticate)

passport.serializeUser (user, done) ->
  done null, user.id

passport.deserializeUser (id, done) ->
  findById id, (err, user) ->
    done err, user

exports.authenticateLogin = ->
  passport.authenticate("local", failureRedirect: "/login", failureFlash: true)

findByUsername = (username, done) ->
  process.nextTick ->
    user = _.find users, (ele) ->
      ele.username is username
    done null, user

findById = (id, done) ->
  process.nextTick ->
    user = _.find users, (ele) ->
      ele.id is id
    delete user.password
    done null, user