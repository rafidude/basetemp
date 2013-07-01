model = require "../models/model"
cons = require "../utils/constants"

transformData = (opts)->
  switch opts.collection
    when 'colldef'
      flds = opts.formData.fields
      console.log -11, flds
      fields = {}
      count = 0
      for k, v of flds
        if count%3 is 0
          key = v
        else
          if count%3 is 1
            val = v
            fields[key] = val
          else
            if v
              primaryKey = val
        count++
      opts.formData.fields = fields
      opts.formData.primaryKey = primaryKey
      opts.rows = 0
  opts

prepareData = (opts) ->
  collection = opts.collection
  formData = opts.formData
  formData.id = 'dummy' unless formData.id
  criteria = {_id: model.ObjectId(formData.id)}
  console.log -14, collection, formData, criteria
  [collection, formData, criteria]
  
exports.deleteFormData = (opts, callback) ->
  [collection, formData, criteria] = prepareData opts
  model.removeObject collection, criteria
  callback null, "success"

exports.saveFormData = (opts, callback) ->
  [collection, formData, criteria] = prepareData opts
  model.updateOrInsertObject collection, criteria, formData
  callback null, "success"

exports.getTableData = (opts, callback) ->
  collection = opts.collection
  model.getData collection, null, null, (err, data)->
    columns = []
    model.getObject 'colldef', {name:collection}, (err, def)->
      for k, v of def.fields
        columns.push k
      pageData = title: collection, data: data, columns: columns, primaryKey: def.primaryKey
      callback err, pageData