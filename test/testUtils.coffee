exports.identical = (a, b, sortArrays) ->
  sort = (object) ->
    if sortArrays is true and Array.isArray(object)
      return object.sort()
    else return object  if typeof object isnt "object" or object is null
    Object.keys(object).sort().map (key) ->
      key: key
      value: sort(object[key])

  JSON.stringify(sort(a)) is JSON.stringify(sort(b))