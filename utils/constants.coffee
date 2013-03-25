exports.writeSafeCollections = ['colldef', 'nameage', 'tt']
exports.readSafeCollections = ['colldef', 'nameage', 'tt']
if process.env.MONGOLAB_URI
  exports.dbUri = process.env.MONGOLAB_URI
  exports.dbenv = "staging or production"
else
  exports.dbUri = "temp"
  exports.dbenv = "local temp"
