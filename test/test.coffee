express = require 'express'
request = require 'supertest'
{ expect } = require 'chai'
{ join } = require 'path'
stylus = require '../src/index'
nib = require 'nib'

publicDir = join __dirname, '/public'

describe 'test if configuration', ->

  it 'functions and variables work', (done) ->
    i = 0
    j = 0
    app = express()
    app.use stylus
      src: publicDir
      use: [nib()]
      import: ['nib']
      includeCss: true
      compress: true
      firebug: true
      linenos: true
      indentSpaces: true
      sourcemap: true
      _testCallback: (type, fnType, fnCall, val) ->
        ++i if type == 'fn' and fnType == 'use'
        ++i if type == 'fn' and fnType == 'import'
        ++j if type == 'var' and val == true
    app.use express.static publicDir
    request(app)
      .get '/test.css'
      .expect 200
      .end (err, {text}) ->
        expect(err).to.be.null
        expect(text).to.have.string('font-weight')
        done() if i == 2 and j == 6
