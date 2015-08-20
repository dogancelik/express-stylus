debug = require('debug')('express-stylus')
stylus = require 'stylus'

variables = ['includeCss:include css', 'compress', 'firebug', 'linenos', 'indentSpaces:indent spaces', 'sourcemap']
functions = ['use', 'import']

split = (variable) ->
  canSplit = variable.indexOf(':') > -1
  splitArr = if canSplit then variable.split(':') else variable
  property = if canSplit then splitArr[0] else splitArr
  setting = if canSplit then splitArr[1] else splitArr

  {
    property: property
    setting: setting
  }

test = -> this._testCallback.apply(null, arguments) if this._testCallback

compile = (str, path) ->
  options = this
  renderer = stylus str

  functions.forEach (fn) ->
    if Array.isArray options[fn]
      options[fn].forEach (i) ->
        test.bind(options) 'fn', fn, i
        debug "using function '%s'", fn
        renderer[fn](i)

  variables.forEach (i) ->
    variable = split i
    if options.hasOwnProperty variable.property
      test.bind(options) 'var', variable.property, variable.setting, options[variable.property]
      debug "setting '%s' to '%s'", variable.setting, options[variable.property].toString()
      renderer.set variable.setting, options[variable.property]

  renderer.set 'filename', path
  renderer

middleware = (options) ->
  options ?= {}
  if typeof options == 'string'
    options = src: options

  options.compile = compile
  stylus.middleware options

module.exports = middleware
