DAMPENING = .01
SEGMENTLENGTH = 25
STIFFNESS = .005
ELECTROSTATIC_FORCE = 15

class @Base
  constructor: (location, @index, @letter, @previous) ->
    @location = {x: location.x + SEGMENTLENGTH * @index, y: location.y + 5 * @index}
    @velocity = {x: 0, y: 0}
    @pair = null
    if @previous
      @previous.next = this
    @fabricObject = @makeFabricObject()
    @fabricObject.obj = this

  teleport: (location) ->
    if @next
      loc = @difference @next
      @line.set x1: 0, y1: 0, x2: -loc.x, y2: -loc.y
      @line.sendToBack()

    @location = {x: location.x, y: location.y}
    @fabricObject.set
      top: @location.y
      left: @location.x
    @fabricObject.setCoords()

  move: (vector) ->
    @teleport
      x: @location.x + vector.x
      y: @location.y + vector.y

  makeFabricObject: ->
    @circle = new fabric.Circle
      fill: '#7c9'
      radius: 12
      originX: 'center'
      originY: 'center'

    text = new fabric.Text @letter,
      fontSize: 15
      originX: 'center'
      originY: 'center'
      fontFamily: 'Helvetica'
      fill: '#fff'

    @line = new fabric.Line(
      [0, 0, 1, 1],
      stroke: '#999',
      strokeWidth: 2,
      selectable: false)

    list = [@line, @circle, text]

    g = new fabric.Group list,
        top: @location.y
        left: @location.x

    g.hasControls = false
    g.hasBorders = false

    g

  colorize: ->
    if @selected
      @circle.set fill: '#79c'
    else if @pair
      @circle.set fill: '#acb'
    else
      @circle.set fill: '#7c9'

  select: ->
    @selected = true
    @colorize()

  unselect: ->
    @selected = false
    @colorize()

  makePair: (other) ->
    if Math.abs(other.index - @index) <= 3
      return
    if @pair or other.pair
      return

    if _.indexOf(["AU", "UA", "GC", "CG", "UG", "GU"], @letter + other.letter) == -1
      return

    @pair = other
    other.pair = this

    @colorize()
    @pair.colorize()

  unpair: ->
    @pair?.pair = null
    @pair?.colorize()
    @pair = null
    @colorize()

  update: (bases) ->
    force = {x: 0, y: 0}
    if @previous
      f = @force @previous
      force.x += f.x
      force.y += f.y

      kink = Math.abs(3.14 - @previous.angle())
      if kink
        f = @difference @previous.previous
        force.x += f.x * kink * STIFFNESS
        force.y += f.y * kink * STIFFNESS

    if @next
      f = @force @next
      force.x += f.x
      force.y += f.y

      kink = Math.abs(3.14 - @next.angle())
      if kink
        f = @difference @next.next
        force.x += f.x * kink * STIFFNESS
        force.y += f.y * kink * STIFFNESS

    if @pair
      f = @force @pair
      force.x += f.x
      force.y += f.y

    force.x += (300 - @location.x) * .01
    force.y += (300 - @location.y) * .01

    f = @electrostatic bases
  #  console.log f.x, f.y
    force.x += f.x * ELECTROSTATIC_FORCE
    force.y += f.y * ELECTROSTATIC_FORCE

    @accelerate(force)

  difference: (other) ->
    x: @location.x - other.location.x
    y: @location.y - other.location.y

  distance: (other) ->
    d = @difference(other)
    Math.sqrt(d.x * d.x + d.y * d.y)

  force: (other) ->
    delta = @difference(other)
    d = @distance(other)
    tension = (d - SEGMENTLENGTH)/d
    x: -1 * delta.x * tension
    y: -1 * delta.y * tension

  accelerate: (force) ->
    @velocity.x = (@velocity.x + force.x) * DAMPENING
    @velocity.y = (@velocity.y + force.y) * DAMPENING

    @velocity.x = Math.min(Math.max(-10, @velocity.x), 10)
    @velocity.y = Math.min(Math.max(-10, @velocity.y), 10)

  step: (steps) ->
    @move
      x: @velocity.x * steps
      y: @velocity.y * steps

  angle: ->
    # The angle between previous and next base

    if not (@previous and @next)
      return 3.14

    dp = @distance @previous
    dn = @distance @next

    p = @difference @previous
    n = @difference @next
    dot = p.x * n.x + p.y * n.y
    cos = dot / (dp * dn)

    Math.acos(cos)

  electrostatic: (bases) ->
    forces = _.map bases, (base) =>
      d = @distance base
      diff = @difference base

      if d == 0
        return {x: 0, y: 0}

      x: diff.x / (d * d)
      y: diff.y / (d * d)

    r = _.reduce forces, (t, f) =>
      if not t
        return f
      x: f.x + t.x
      y: f.y + t.y
