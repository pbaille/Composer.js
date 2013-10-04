define ["lib/utils/Module"], ->
  
  if typeof global != "undefined" && global != null 
    root= global.AC.Utils
  else
    root= window.AC.Utils

  Module = AC.Utils.Module 

  moduleKeywords = ['extended', 'included']
  
  class Module
    @extend: (obj) ->
      for key, value of obj when key not in moduleKeywords
        @[key] = value
  
      obj.extended?.apply(@)
      this
  
    @include: (obj) ->
      for key, value of obj when key not in moduleKeywords
        # Assign properties to the prototype
        @::[key] = value
  
      obj.included?.apply(@)
      this

  
  ###################################################

  mixOf = (base, mixins...) ->
    class Mixed extends base
    for mixin in mixins by -1 #earlier mixins override later ones
      for name, method of mixin::
        Mixed::[name] = method
    Mixed
  
  # example 

  # class DeepThought
  #   answer: ->
  #     42
      
  # class PhilosopherMixin
  #   pontificate: ->
  #     console.log "hmm..."
  #     @wise = yes
  
  # class DeeperThought extends mixOf DeepThought, PhilosopherMixin
  #   answer: ->
  #     @pontificate()
  #     super()
         

