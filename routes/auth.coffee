passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
_ = require 'underscore'

exports.authSetup = (app) ->
  app.use passport.initialize()
  app.use passport.session()

authenticate = (username, password, done) ->
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

passport.use new LocalStrategy(authenticate)

passport.serializeUser (user, done) ->
  done null, user.id

passport.deserializeUser (id, done) ->
  findById id, (err, user) ->
    done err, user

exports.authenticateLogin = ->
  passport.authenticate("local", failureRedirect: "/login", failureFlash: true)

users = [
  id: 1, username: "bob", password: "secret", email: "bob@example.com"
,
  id: 2, username: "joe", password: "birthday", email: "joe@example.com"
]

exports.ensureAuthenticated = (req, res, next) ->
  return next()  if req.isAuthenticated()
  res.redirect "/login"

exports.account = (req, res) ->
  res.render "account",
    user: req.user

exports.login = (req, res) ->
  res.render "login",
    user: req.user
    message: req.flash("error")

findByUsername = (username, done) ->
  process.nextTick ->
    user = _.find users, (ele) ->
      ele.username = username
    done null, user

exports.findById = findById = (id, done) ->
  process.nextTick ->
    user = _.find users, (ele) ->
      ele.id = id
    done null, user