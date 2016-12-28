class Dashing.Clock extends Dashing.Widget

  ready: ->
    setInterval(@startTime, 500)

  startTime: =>
    today = new Date()
    h = today.getHours()
    seattle = h - 3

    if (h > 12)
      h -= 12
    else if (h == 0)
      h = 12

    m = today.getMinutes()
    s = today.getSeconds()
    m = @formatTime(m)
    s = @formatTime(s)

    @set('time', h + ":" + m)
    @set('date', today.toDateString())
    @set('seattle-time', "Seattle: " + seattle + ":" + m)

  formatTime: (i) ->
    if i < 10 then "0" + i else i
