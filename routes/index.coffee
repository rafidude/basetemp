exports.index = (req, res) ->
  res.render "index",
    title: "Base Template"
    
exports.nameage = (req, res) ->
  console.log -111, req.body
  res.send "blah"