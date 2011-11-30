###
  multiplication.coffee

  a demo webworker for mutiplication:
###
define [
  'underscore'
], (_) ->
    self.postMessage('before binding')
    self.onmessage = (e) ->
        self.postMessage('hello from worker!')
        result = _.reduce(e.data, ((memo, elem) -> memo * elem), 1)
        self.postMessage(result)
        true
    self.postMessage('after binding')
    true

