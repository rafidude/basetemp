express = require("express")
routes = require("./routes")
http = require("http")
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
  app.use express.session()
  app.use express.static(__dirname + "/public")
  app.use app.router

app.configure "development", ->
  app.use express.errorHandler()

app.get "/", (req, res)->
  res.render "index", title:"index"

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