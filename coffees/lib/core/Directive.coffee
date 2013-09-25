define [], ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core

  class root.Directive

    constructor: (opt) ->  

      @position= opt.position
      @type = opt.type #rythmic || harmonic || melodic || dynamic
      @method_name = opt.method_name # string => name of the method to call with @args on the receiver
      @args = opt.args # array of args 
