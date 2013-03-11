model = require "../models/model"
cons = require "../utils/constants"

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
    callback {error: "something failed"}, null

exports.saveFormData = (opts, callback) ->
  collection = opts.collection
  if cons.writeSafeCollections.indexOf(collection) > -1
    formData = opts.formData
    # model.saveObject collection, formData
    primaryKey = 'name'
    criteria = {}
    criteria[primaryKey] = formData[primaryKey]
    model.updateOrInsertObject collection, criteria, formData
    callback null, "success"
  else
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
