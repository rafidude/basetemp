mu = require "../models/modelUtils"

exports.page = (req, res) ->
  page = req.params.page
  page = "index" if not page
  res.render page, title: page

exports.deleteFormData = (req, res) ->
  opts = {}
  opts.collection = req.params.resource
  opts.formData = req.body
  mu.deleteFormData opts, (err, succ)->
    if succ
      res.send "success"
    else
      res.send 500, err

exports.saveFormData = (req, res) ->
  opts = {}
  opts.collection = req.params.resource
  opts.formData = req.body
  mu.saveFormData opts, (err, succ)->
    if succ
      res.send "success"
    else
      res.send 500, err

exports.getTableData = (req, res) ->
  opts = {}
  opts.collection = req.params.coll
  mu.getTableData opts, (err, data)->
    res.render 'collTable', data