cons = require("../utils/constants")
console.log "Connecting to DB Environment #{cons.dbenv}"
db = require("mongojs").connect(cons.dbUri)

#obj: single js object
#data: array of js objects

exports.getObjectById = getObjectById = (table, id, callback) ->
  criteria = {_id: db.ObjectId(id)} unless criteria
  db.collection(table).findOne criteria, (err, obj) ->
    callback err, obj

exports.getObject = getObject = (table, criteria, callback) ->
  criteria = {} unless criteria
  db.collection(table).findOne criteria, (err, obj) ->
    callback err, obj

exports.getObjectsIn = (table, criteria, fieldName, arr, callback) ->
  criteria = {} unless criteria
  criteria[fieldName] = {$in: arr}
  db.collection(table).find criteria, (err, obj) ->
    callback err, obj

exports.getData = (table, criteria, fields, callback) ->
  criteria = {} unless criteria
  fieldsObj = transformFields fields
  db.collection(table).find criteria, fieldsObj, (err, data) ->
    callback err, data

exports.getSortedData = (table, criteria, fields, sortArr, callback) ->
  criteria = {} unless criteria
  fieldsObj = transformFields fields
  sortObj = {sort:sortArr}
  db.collection(table).find criteria, fieldsObj, sortObj, (err, data) ->
    callback err, data
    
exports.getCount = (table, criteria, callback) ->
  criteria = {} unless criteria
  db.collection(table).count criteria, (err, count) ->
    callback err, count
    
exports.removeObject = (table, criteria, callback) ->
  criteria = {} unless criteria
  db.collection(table).remove criteria, (err, removed) ->
    callback err, removed if callback    

exports.saveObject = (table, obj, callback) ->
  db.collection(table).save obj, (err, saved) ->
    callback err, saved if callback

exports.updateObject = (table, criteria, obj, callback) ->
  db.collection(table).update criteria, {$set:obj}, (err, updated) ->
    callback err, updated if callback

# This will insert a new row if the criteria is not matched: used in CSV upload and data sync
exports.updateOrInsertObject = (table, criteria, obj, callback) ->
  db.collection(table).update criteria, {$set:obj}, {upsert: true}, (err, updated) ->
    callback err, updated if callback

# custom updates obj with $push, $pull
exports.updateObjectCustom = updateObjectCustom = (table, criteria, obj, callback) ->
  db.collection(table).update criteria, obj, (err, updated) ->
    callback err, updated if callback

exports.getDataArray = (table, criteria, fieldName, callback) ->
  throw {message:'fieldName is required'} unless fieldName
  criteria = {} unless criteria
  fields = {}
  fields[fieldName] = 1
  fields['_id'] = 0
  db.collection(table).find criteria, fields, (err, data) ->
    arr = []
    for row in data
      arr.push row[fieldName]
    arr = arr.sort()
    callback err, arr

exports.copyCollection = (table, newtable, callback) ->
  getData table, null, null, (err, data)->
    saveObject newtable, data, (err, succ)->
      callback err, succ

exports.dropCollection = (table, callback) ->
  db.collection(table).drop (err, success) ->
    callback err, success if callback

transformFields = (fields) ->
  fieldsObj = {_id: 0}
  type = typeof fields
  switch type
    when 'string'
      fields = fields.split(',')
      for field in fields
        fieldsObj[field.trim()] = 1
    when 'object'
      fieldsObj = fields if fields
      if Object.prototype.toString.call(fields) is '[object Array]'
        for field in fields
          fieldsObj[field] = 1
    when 'undefined'
      fieldsObj = {}
  fieldsObj

exports.getNextID = getNextID = (type, callback) ->
  field = type + 'Seq'
  model.getObject 'globals', {ID:field}, (err, doc) ->
    if doc
      globalIncrement 'globals', field, (err, succ) ->
        id = doc[field]
        id = "a" + id if type is 'account'
        callback err, id
    else
      callback null, null

globalIncrement = (table, field, callback) ->
  obj = {}
  obj[field] = 1
  cri = {}
  cri.ID = field
  cri['$atomic'] = 1
  model.updateObjectCustom table, cri, {$inc: obj}, (err, result) ->
    if err then callback err, null else callback null, result if callback?