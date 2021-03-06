baseUrl = "http://127.0.0.1:4000/"

passport = require 'passport'

exports.authSetup = (app) ->
  app.use passport.initialize()
  app.use passport.session()

passport.serializeUser (user, done) ->
  done null, user.id

passport.deserializeUser (obj, done) ->
  done null, obj

# Dropbox Auth Strategy
DropboxStrategy = require('passport-dropbox').Strategy
DROPBOX_APP_KEY = "su10ytaxv0js1ac"
DROPBOX_APP_SECRET = "la67olph2o4lk6e"
dropboxCredentials = 
  consumerKey: DROPBOX_APP_KEY
  consumerSecret: DROPBOX_APP_SECRET
  callbackURL: baseUrl + "auth/dropbox/callback"

dropboxAuthenticate = (accessToken, refreshToken, profile, done) ->
  console.log -25, profile.id, profile.emails[0].value, profile.displayName
  doSomething accessToken
  done null, profile

doSomething = (accessToken)->
  dbox = require 'dbox'
  app = dbox.app app_key: DROPBOX_APP_KEY, app_secret: DROPBOX_APP_SECRET
  client = app.client accessToken
  client.account (status, reply) ->
    console.log -31, accessToken, status, reply

passport.use new DropboxStrategy(dropboxCredentials, dropboxAuthenticate)

exports.authenticateDropboxLogin = ->
  dropboxAuthOptions = 
    successReturnToOrRedirect: "/settings"
    failureRedirect: "/login"
  passport.authenticate("dropbox", dropboxAuthOptions)

# Google Auth Strategy
GoogleStrategy = require('passport-google-oauth').OAuth2Strategy
GOOGLE_CLIENT_ID = "711413099716.apps.googleusercontent.com"
GOOGLE_CLIENT_SECRET = "hHLdA97mB8__B1rxGW7jsOsz"
googleCredentials = 
  clientID: GOOGLE_CLIENT_ID
  clientSecret: GOOGLE_CLIENT_SECRET
  callbackURL: baseUrl + "auth/google/callback"

googleAuthenticate = (accessToken, refreshToken, profile, done) ->
  console.log -21, profile.emails[0].value, profile.displayName
  done null, profile

passport.use new GoogleStrategy(googleCredentials, googleAuthenticate)

exports.authenticateGoogleLogin = ->
  googleAuthOptions = 
    scope: ['https://www.googleapis.com/auth/userinfo.profile', 'https://www.googleapis.com/auth/userinfo.email']
    successReturnToOrRedirect: "/settings"
    failureRedirect: "/login"
  passport.authenticate("google", googleAuthOptions)

# Facebook Auth Strategy
FacebookStrategy = require('passport-facebook').Strategy
FACEBOOK_CLIENT_ID = "1381203388769841"
FACEBOOK_CLIENT_SECRET = "6c74c3a4f021e269042a4c513b605d3a"
facebookCredentials = 
  clientID: FACEBOOK_CLIENT_ID
  clientSecret: FACEBOOK_CLIENT_SECRET
  callbackURL: baseUrl + "auth/facebook/callback"

facebookAuthenticate = (accessToken, refreshToken, profile, done) ->
  console.log -23, profile.id, profile.username, profile.displayName
  done null, profile

passport.use new FacebookStrategy(facebookCredentials, facebookAuthenticate)

exports.authenticateFacebookLogin = ->
  passport.authenticate("facebook", successReturnToOrRedirect: "/settings", failureRedirect: "/login")

# Twitter Auth Strategy
TwitterStrategy = require('passport-twitter').Strategy
TWITTER_CONSUMER_KEY = "xweXsA7AAxVZ3uiVpnu7A"
TWITTER_CONSUMER_SECRET = "VMHeAB3xfX42VBLfANZeEFqSgPF4pN1Fv0pf044w8p8"

twitterCredentials = 
  consumerKey: TWITTER_CONSUMER_KEY
  consumerSecret: TWITTER_CONSUMER_SECRET
  callbackURL: baseUrl + "auth/twitter/callback"

twitterAuthenticate = (token, tokenSecret, profile, done) ->
  console.log -22, profile.id, profile.username, profile.displayName
  done null, profile

passport.use new TwitterStrategy(twitterCredentials, twitterAuthenticate)

exports.authenticateTwitterLogin = ->
  passport.authenticate("twitter", successReturnToOrRedirect: "/settings", failureRedirect: "/login")

# Local Strategy Auth
LocalStrategy = require('passport-local').Strategy
_ = require 'underscore'

users = [
  id: 1, username: "bob", password: "secret", email: "bob@example.com"
,
  id: 2, username: "joe", password: "birthday", email: "joe@example.com"
,
  id:3, username: 'tt', password: 'tt', email: 'tt@tt.tt'
]

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

exports.authenticateLocalLogin = ->
  passport.authenticate("local", failureRedirect: "/login", failureFlash: true)

findByUsername = (username, done) ->
  process.nextTick ->
    user = _.find users, (ele) ->
      ele.username is username
    done null, user

# ForceDotCom Auth Strategy
# ForceDotComStrategy = require('passport-forcedotcom').Strategy
# FORCEDOTCOM_CLIENT_ID = "1381203388769841"
# FORCEDOTCOM_CLIENT_SECRET = "6c74c3a4f021e269042a4c513b605d3a"
# forcedotcomCredentials = 
#   clientID: FORCEDOTCOM_CLIENT_ID
#   clientSecret: FORCEDOTCOM_CLIENT_SECRET
#   callbackURL: baseUrl + "auth/forcedotcom/callback"
# 
# forcedotcomAuthenticate = (accessToken, refreshToken, profile, done) ->
#   done null, profile
# 
# passport.use new ForceDotComStrategy(forcedotcomCredentials, forcedotcomAuthenticate)
# 
# exports.authenticateForceDotComLogin = ->
#   passport.authenticate("forcedotcom", successReturnToOrRedirect: "/settings", failureRedirect: "/login")