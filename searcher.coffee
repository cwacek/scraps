request = require 'ahr2'
sys = require 'sys'
events = require 'events'
jsdom = require 'jsdom'

jQueryPath = 'http://code.jquery.com/jquery-1.8.3.min.js'
headers =
    accept: "application/json"
    "content-type" : "application/json"


Searcher = (param) ->
    if param.headers
        this.headers = param.headers
    else
        this.headers = headers

    this.base_url = param.base_url

Searcher.prototype = new process.EventEmitter

Searcher.prototype.search = (query, collector) ->
    self = this
    url = self.getSearchUrl query

    console.log 'Connecting to... ' + url
    req =
        href: url
        method: "GET"
        headers: self.headers
        timeout: 10000

    request req, (err,response, html) ->
        if err
            self.onError {error: err, searcher: self}
            self.onComplete {searcher: self}
        else
            console.log "Fetched content from... " + url
            env =
              html: html
              scripts: [jQueryPath]
              done: (errors, window) ->
                if errors > 0
                  console.log "Error parsing DOM:" + errors
                self.parseHtml window
                self.onComplete {searcher: self}

            jsdom.env(env)

Searcher.prototype.getSearchUrl = (query) ->
    throw "getSearchUrl() unimplemented!"

Searcher.prototype.parseHtml= (window) ->
    throw "parseHtml() unimplemented!"

Searcher.prototype.onItem= (item) ->
    this.emit 'item', item

Searcher.prototype.onComplete= (searcher) ->
    this.emit 'complete', searcher

Searcher.prototype.onError = (error) ->
    this.emit 'error' ,error

module.exports = Searcher
