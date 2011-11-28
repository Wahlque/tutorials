###
  multiplication.coffee

  a demo webworker for mutiplication:
###
( ->

    global = this

    define [
      'underscore'
    ], (_) ->
        postMessage('before binding')
        global.onmessage = (e) ->
            postMessage('hello from worker!')
            result = _.reduce(_.values(e.data), ((memo, elem) -> memo * elem), 1)
            postMessage(result)
            false

)()

