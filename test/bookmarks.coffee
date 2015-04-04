async = require "async"
fs = require "fs"
glob = require "glob"
yaml = require "js-yaml"

request = require "request"
expect = require("chai").expect

files = glob.sync "_data/*.yml"

_TestLink = (link, callback) ->
    describe link.title, ->
        it "responds with 200", (done) ->
            request.get link.url, (err, res, body) ->
                expect(res.statusCode).to.equal 200
                done()
    callback()

_TestCategory = (file, callback) ->
    category = yaml.safeLoad fs.readFileSync file, "utf8"
    describe category.name, ->
        async.each category.links, (link, callback2) ->
            _TestLink link, callback2
        , (err) ->
            if err
                console.log "A link failed to process."
            else
                console.log "All '#{category.name}' links have been processed successfully."
    callback()

async.each files, (file, callback) ->
    _TestCategory file, callback
, (err) ->
    if err
        console.log "A file failed to process."
    else
        console.log "All files have been processed successfully."
