###
 * cylon sphero adaptor
 * http://cylonjs.com
 *
 * Copyright (c) 2013 The Hybrid Group
 * Licensed under the Apache 2.0 license.
###

'use strict';

require './cylon-sphero'
Spheron = require 'spheron'
Colors = require './colors'
namespace = require 'node-namespace'

namespace "Cylon.Adaptor", ->
  class @Sphero extends Cylon.Basestar
    constructor: (opts) ->
      super
      @connection = opts.connection
      @name = opts.name
      @sphero = Spheron.sphero()
      @connector = @sphero
      @proxyMethods Cylon.Sphero.Commands, @sphero, Sphero

    commands: -> Cylon.Sphero.Commands

    connect: (callback) ->
      Logger.info "Connecting to Sphero '#{@name}'..."

      @createAdaptorEvent(on: 'open', emit: 'connect', emitUpdate: true)
      @createAdaptorEvent(on: 'close', emit: 'disconnect', emitUpdate: true)
      @proxyAdaptorEvent(on: 'error', emitUpdate: true)
      @proxyAdaptorEvent(on: 'data', emitUpdate: true)
      @proxyAdaptorEvent(on: 'message', emitUpdate: true)
      @proxyAdaptorEvent(on: 'notification', emitUpdate: true)

      @sphero.open(@connection.port.toString())
      (callback)(null)

    disconnect: ->
      Logger.info "Disconnecting from Sphero '#{@name}'..."
      @sphero.close

    detectCollisions: ->
      @sphero.configureCollisionDetection(0x01, 0x40, 0x40, 0x50, 0x50, 0x50,)

    setRGB: (color, persist) ->
      @sphero.setRGB(color, persist)

    setColor: (color, persist = true) ->
      color = Colors.fromString(color) if typeof color is 'string'
      @setRGB color, persist

    setRandomColor: (persist = true) ->
      color = Colors.randomColor()
      @setRGB color, persist

    stop: ->
      @sphero.roll(0, 0, 0)
  
