define ["lib/core/RVal","vendors/ruby"], ->
  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core 

  RVal = AC.Core.RVal

  class root.Bar 
    constructor: (opt) ->

      @bpm = opt.bpm
      @beats = opt.beats #number of beat in the bar
      @beat_val = opt.beat_val #length of a beat (RVal)

      # resolution : RVal caution! -> ( @beats * @beat_val ) % @resolution must == 0 
      # if null defer to timeline resolution
      @resolution = opt.resolution || null 

      # directives (time positioned indications)
      @harmonic_directives = opt.harmonic_directives || [] # array of {at: position, mode: mode object}
      @rythmic_directives = opt.rythmic_directives || []
      @melodic_directives = opt.melodic_directives || []
      @bpm_directives = opt.bpm_directives || []

    duration: ->
      @beat_val.times(@beats)

    ms_duration: ->
      # CAUTION !!!! only works for uniform bpm bar
      if _a.empty(@bpm_directives)
        return @duration().times(new RVal(60,@bpm)).toFloat() * 1000 
      else
        return "not yet implemented"

    ms_duration_at: (sub) ->
      # CAUTION !!!! only works for uniform bpm bar
      if _a.empty(@bpm_directives)
        return 0 if sub.isZero()
        res = sub.div(@duration()).toFloat() * @ms_duration()  
        return res
      else
        return "not yet implemented"

    h_dir_at: (sub) ->
      result = {}	
      for hd in @harmonic_directives
      	break if hd.at.gt(sub)
      	result = hd.mode
      return result	

    m_dir_at: (sub) ->
      result = {} 
      for md in @melodic_directives
        break if md.at.gt(sub)
        result = md
      return result 

    bpm_dir_at: (sub) ->

    r_dir_at: (sub) ->
        
      

