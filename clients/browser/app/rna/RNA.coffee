# @requires ../base/Base

class @RNA
  constructor: (@location, baseString) ->
    @bases = []

    _.each baseString, (letter, i) =>
      base = new Base(@location, i, letter, @bases[@bases.length - 1])
      @bases.push base

    @fabricObjects = @makeFabricObject()

  update: ->
    _.each @bases, (base) =>
      base.update @bases

  step: (steps) ->
    _.each @bases, (base) ->
      base.step steps

  makeFabricObject: () ->
    _.pluck(@bases, 'fabricObject')
