model = require "../models/model"
table = "nameage"

exports.index = (req, res) ->
  res.render "index",
    title: "Base Template"
    
exports.nameage = (req, res) ->
  row = req.body
  model.updateOrInsertObject table, {name: row.name}, row
  # res.send "success"
  res.send 500, {error: "something failed"}

exports.page = (req, res) ->
  page = req.params.page
  console.log -11, page
  res.render page, title: page, data: [{name:'a', age:1}, {name:'b', age:2}]