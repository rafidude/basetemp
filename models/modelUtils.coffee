model = require "../models/model"
cons = require "../utils/constants"

transformData = (opts)->
  switch opts.collection
    when 'colldef'
      flds = opts.formData.fields
      fields = {}
      count = 0
      for k, v of flds
        if count%2 is 0
          key = v
        else
          val = v
          fields[key] = val
        count++
      opts.formData.fields = fields
      opts.rows = 0
  opts

exports.deleteFormData = (opts, callback) ->
  collection = opts.collection
  if cons.writeSafeCollections.indexOf(collection) > -1
    formData = opts.formData
    primaryKey = 'name'
    criteria = {}
    criteria[primaryKey] = formData[primaryKey]
    model.removeObject collection, criteria
    callback null, "success"
  else
    console.log -901, "#{collection} not in writeSafeCollections"
    callback {error: "something failed"}, null

exports.saveFormData = (opts, callback) ->
  transformData opts
  console.log -124, opts
  collection = opts.collection
  if cons.writeSafeCollections.indexOf(collection) > -1
    formData = opts.formData
    primaryKey = 'name'
    criteria = {}
    criteria[primaryKey] = formData[primaryKey]
    model.updateOrInsertObject collection, criteria, formData
    callback null, "success"
  else
    console.log -902, "#{collection} not in writeSafeCollections"
    callback {error: "something failed"}, null

exports.getTableData = (opts, callback) ->
  collection = opts.collection
  if cons.readSafeCollections.indexOf(collection) > -1
    model.getData collection, null, null, (err, data)->
      columns = []
      for k, v of data[0]
        columns.push k
      pageData = title: collection, data: data, columns: columns, primaryKey: 'name'
      callback err, pageData
  else
    console.log -903, "#{collection} not in readSafeCollections"
    callback {error: "something failed"}, null
  
