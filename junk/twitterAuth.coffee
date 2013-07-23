baseUrl = "http://127.0.0.1:4000/"
TWITTER_CONSUMER_KEY = "xweXsA7AAxVZ3uiVpnu7A"
TWITTER_CONSUMER_SECRET = "VMHeAB3xfX42VBLfANZeEFqSgPF4pN1Fv0pf044w8p8"
passport = require 'passport'
TwitterStrategy = require('passport-twitter').Strategy

exports.authSetup = (app) ->
  app.use passport.initialize()
  app.use passport.session()

twitterCredentials = 
  consumerKey: TWITTER_CONSUMER_KEY
  consumerSecret: TWITTER_CONSUMER_SECRET
  callbackURL: baseUrl + "auth/twitter/callback"

twitterAuthenticate = (token, tokenSecret, profile, done) ->
  user = profile
  done null, user

passport.use new TwitterStrategy(twitterCredentials, twitterAuthenticate)

passport.serializeUser (user, done) ->
  done null, user.id

passport.deserializeUser (obj, done) ->
  done null, obj

exports.authenticateLogin = ->
  passport.authenticate("twitter", successReturnToOrRedirect: "/settings", failureRedirect: "/login")
