searcher = require './ncaam.example'

if process.argv.length < 3
    console.log "Not enough arguments provided."
    process.exit(1)

searcher.on 'item', (item) ->
    console.log "Found >> " + item.time

searcher.on 'complete', (searcher) ->
    console.log "Done!"

searcher.on 'error', (error) ->
    console.log "Error."
    console.log error

searcher.search process.argv[2]
