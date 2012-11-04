class Dashing.Graph extends Dashing.Widget

  @accessor 'current', ->
    return @get('displayedValue') if @get('displayedValue')
    views = @get('pointsTwo')

    if views
      views[views.length - 1].y

  @accessor 'people', ->
    people = @get('points')

    if people
      people[people.length - 1].y


  ready: ->
    container = $(@node).parent()
    # Gross hacks. Let's fix this.
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))

    @graph = new Rickshaw.Graph(
      element: @node
      width: width
      height: height
      renderer: 'area'
      series: [
        {
          color: "#fff",
          data: [{ x:0, y:0 }]
        },
        {
          color: "#000",
          data: [{ x:0, y:0 }]
        }
      ]
    )


    @graph.series[0].data = @get('points') if @get('points')
    @graph.series[1].data = @get('pointsTwo') if @get('pointsTwo')

    x_axis = new Rickshaw.Graph.Axis.Time(graph: @graph)
    y_axis = new Rickshaw.Graph.Axis.Y(graph: @graph, tickFormat: Rickshaw.Fixtures.Number.formatKMBT)

    @graph.renderer.unstack = true
    @graph.render()

  onData: (data) ->
    if @graph
      @graph.series[0].data = data.points
      @graph.render()
