test = require "../test"
expect = require "expect.js"

delay = (ms, func) -> setTimeout func, ms
  
describe "Array", ->
  describe "#indexOf()", ->
    it "should return -1 when the value is not present", ->
      [1, 2, 3].indexOf(5).should.equal -1
      [1, 2, 3].indexOf(0).should.equal -1
  
describe "async test", ->
  it "should return 1 for [1, 2, 3] index of 2", (done)->
    delay 1000, ->
      expect([1, 2, 3].indexOf(2)).to.be 1
      done()
