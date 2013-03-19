Searcher = require './grabber'

config =
    base_url: 'http://espn.go.com/mens-college-basketball/schedule'

searcher = new Searcher config

module.exports = searcher

searcher.getSearchUrl = (query) ->
    return this.base_url + "?date=" + query

searcher.parseHtml = (window) ->
    self = this
    console.log "Parsing HTML"

    get_text = (item,filter) ->
        return item.find(filter).text()

    window.$('.oddrow,.evenrow').each  ->
        item = window.$ this
        found =
            time: get_text item, "td:first-child"

        self.onItem found

