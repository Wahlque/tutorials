###
  csmain.coffee

  link for this section:
  http://playground.wahlque.org/tutorials/graphics/001-terrain-gen
###
define [
  'underscore'
  'domReady'
  'qwery'
  'bonzo'
  'bean'
  'cs!accumulator'
  'cs!transformer'
  'cs!starlight'
  'cs!viewer'
  'cs!/wahlque/physics/units/au'
  'cs!/wahlque/universe/wahlque/planet/planet'
], (_, domReady, qwery, bonzo, bean, accumulator, transformer, starlight, viewer, au, planet) ->
    $ = (selector) -> bonzo(qwery(selector))

    domReady ->
        tmp = null
        map = null
        frame = [[1, 0, 0], [0, 1, 0], [0, 0, 1]]

        worker = new Worker './worker.js'
        worker.onmessage = (event) ->
            data = event.data
            if data.msg
                $("#msg").html(data.msg)
                map = tmp
            else if data.trn
                tmp = data.trn

        invoke = ->
            worker.postMessage('start')
            $("#msg").html('Initializting the terrain data')
            true

        changeframe = (e) ->
            canvas = $('#canvas').get(0)
            width = canvas.width
            height = canvas.height

            x = y = 0
            if e.pageX || e.pageY
              x = e.pageX
              y = e.pageY
            else
              x = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft
              y = e.clientY + document.body.scrollTop + document.documentElement.scrollTop
            x -= canvas.offsetLeft
            y -= canvas.offsetTop
            x = x - width / 2
            y = y - height / 2

            if x > 0
                frame = rotater.left(frame, - x / width * 2)
            else
                frame = rotater.right(frame, x / width * 2)

            if y > 0
                frame = rotater.up(frame, y / height * 2)
            else
                frame = rotater.down(frame, - y / height * 2)

        bean.add(
            $('#btnStart').get(0), 'click', (-> invoke())
        )
        bean.add(
            $('#canvas').get(0), 'click', changeframe
        )

        time = 0
        counter = 0
        evolve = ->
            return if map == null
            tao = planet.period / 30 #SI
            lights = starlight.evolve(au.fromSI_T(tao))
            data = accumulator.accumulate(tao, time, lights[0], lights[1])

            viewer.paint(transformer.target(frame, (time / planet.period)), map, data)
            counter = (counter + 1) % 30
            $("#msg").html('counter: ' + counter)
            time += tao
        handle = setInterval(evolve, 10000)

       true
