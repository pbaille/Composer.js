require.config

  urlArgs: 'cb=' + Math.random()

  paths: 
    jquery: 'vendors/jquery-1.10.2.min'
    'jasmine': 'spec/jasmine/jasmine'
    'jasmine-html': 'spec/jasmine/jasmine-html'
    spec: 'spec/'

  shim: 
    jasmine: 
      exports: 'jasmine'
    'jasmine-html': 
      deps: ['jasmine']
      exports: 'jasmine'
    
window.AC = {}

window.AC.Core = {}
window.AC.MIDI = {}
window.AC.Utils = {}
window.AC.GUI = {}

require ["jquery", "jasmine-html"], ($, jasmine) ->

  jasmineEnv = jasmine.getEnv()
  jasmineEnv.updateInterval = 1000
  htmlReporter = new jasmine.HtmlReporter()
  jasmineEnv.addReporter htmlReporter

  jasmineEnv.specFilter = (spec) ->
    htmlReporter.specFilter spec
  
  specs = [
    "spec/RVal.spec"
    "spec/Degree.spec"
    "spec/Array_adds.spec"
    "spec/AbstractMode.spec"
    "spec/Mode.spec"
    "spec/Constants.spec"
    "spec/Domain.spec"
    "spec/HarmonicContext.spec"
    "spec/Bar.spec"
    "spec/TimeLine.spec"

  ]

  $ ->
    require specs, (spec) ->
      jasmineEnv.execute()  