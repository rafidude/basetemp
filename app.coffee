express = require "express"
flash = require "connect-flash"
routes = require "./routes/formdata"
auth = require "./routes/allAuth"
_ = require 'underscore'
ensureLoggedIn = require('connect-ensure-login').ensureLoggedIn

http = require "http"
app = express()

app.configure "development", ->
  app.set "port", process.env.PORT or 4000
  app.use express.errorHandler  dumpExceptions: true, showStack:true
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.favicon()
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser("your secret here")
  app.use express.session({ secret: 'keyboard cat' })
  auth.authSetup app
  app.use flash()
  app.use express.static(__dirname + "/public")
  app.use app.router

app.configure "development", ->
  app.use express.errorHandler()

app.get "/", (req, res)->
  res.render "index", title:"index"

app.get "/auth/twitter", auth.authenticateTwitterLogin()
app.get "/auth/twitter/callback", auth.authenticateTwitterLogin()

app.get "/auth/facebook", auth.authenticateFacebookLogin()
app.get "/auth/facebook/callback", auth.authenticateFacebookLogin()

app.get "/auth/forcedotcom", auth.authenticateForceDotComLogin()
app.get "/auth/forcedotcom/callback", auth.authenticateForceDotComLogin()

app.get "/auth/google", auth.authenticateGoogleLogin()
app.get "/auth/google/callback", auth.authenticateGoogleLogin()

app.get "/auth/dropbox", auth.authenticateDropboxLogin()
app.get "/auth/dropbox/callback", auth.authenticateDropboxLogin()

app.post "/login", auth.authenticateLocalLogin(), (req, res) ->
  if req.session.returnTo then redirUrl = req.session.returnTo else redirUrl = '/account'
  res.redirect redirUrl

app.get "/login", (req, res)->
  res.render "login", user: req.user, message: req.flash("error")

app.get "/account", ensureLoggedIn("/login"), (req, res) ->
  res.render "account", user: req.user

app.get "/settings", ensureLoggedIn("/login"), (req, res) ->
  res.render "settings", user: req.user

app.get "/logout", (req, res) ->
  req.logout()
  res.redirect "/"

# Any plain jade page 
app.get "/:page", routes.page

app.get "/collection/:coll", routes.getCollectionData #Get data from collection in JSON
# Grid page shows data from given collection
app.get "/table/:coll", routes.getTableData #Get data from collection, render tabular page

app.post "/save/:resource", routes.saveFormData

app.post "/delete/:resource", routes.deleteFormData

http.createServer(app).listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

process.on 'uncaughtException', (err)->
  console.log -998, 'uncaughtException', err