define [
  "lib/core/base/Constants"
  "lib/core/base/Note"
  "lib/core/base/Degree"
  "lib/core/base/AbstractMode"
  "vendors/ruby"
  ], ->

  if typeof global != "undefined" && global != null 
    root= global.AC.Core
  else
    root= window.AC.Core 

  MK= root.MK
  PitchClass = root.PitchClass
  AbstractMode= root.AbstractMode
  Degree = root.Degree

  class root.Mode

  	# utility
    @Moth= (root, name, functs) ->
      {root: root
      name: name
      functs: functs}

    constructor: (o) ->

      o= {name: o} if typeof o is "string"
      o= {concrete: o} if o instanceof Array
      
      if o.concrete
        @root= new PitchClass(o.concrete[0])
        @concrete= o.concrete
        @abstract_calc()
        @name_calc()
        @mother_calc()

      else if o.name
        if o.name.split(' ').length == 2 then @name = o.name else @name = "C #{o[name]}"
        @root= new PitchClass @name.split(' ')[0]
        @abstract= new AbstractMode @name.split(' ')[1]
        @concrete_calc()
        @mother_calc()

      else if o.abstract and o.root
        @root= new PitchClass o.root
        if o.abstract instanceof AbstractMode then @abstract= o.abstract else @abstract= new AbstractMode o.abstract
        @concrete_calc()
        @name_calc()
        @mother_calc()

      else if o.mother and o.degree
        @abstract= new AbstractMode o.mother.split(' ')[1], o.degree
        @root= new PitchClass(MK.PITCHES[o.mother.split(' ')[0]] + @abstract.moth_offset())
        @concrete_calc()
        @mother_calc()
        @name_calc()

      else p "have to provide abstract/root or concrete or name or mother/degree"

      @degrees_calc()
      @prio= o.prio || @prio_calc()

 #    #************************** CALCULUS ***********************************

    root_calc: ->
      @root= new PitchClass(@concrete[0])

    abstract_calc: ->
      @abstract= new AbstractMode(_a.tonicize(@concrete))

    concrete_calc: ->
      r = @root
      @concrete= @abstract.functs.map (x) => (x + r.int ) % 12

    prio_calc: ->
      @prio= @abstract.prio

    name_calc: ->
      if @abstract.name
        @name=  @root.name + " " + @abstract.name 
      else
        @name= @root.name + " Unknown"

    mother_calc: ->
      r = @mother_root()
      @mother= root.Mode.Moth(r, _h.key(MK.PITCHES , r ) + " " + @abstract.mother.name , @abstract.mother.functs)

    degrees_calc: ->
      @degrees={}
      for x,i in @abstract.functs
        @degrees[MK.ABSTRACT_DEGREES[i]] = new Degree(MK.ABSTRACT_DEGREES[i], x)

	
 #    #************************** SETTERS ***********************************

    set_root: (arg) ->
      if arg instanceof PitchClass then @root = arg else @root = new PitchClass(arg)
      @concrete_calc()
      @name_calc()
      @mother_calc()
    

    set_abstract: (arg) ->
      if arg instanceof Array
        @abstract = new AbstractMode arg
      else
        @abstract = arg

      @concrete_calc()
      @name_calc()
      @prio_calc()
      @mother_calc()
      @degrees_calc()
    

    set_concrete: (arg) ->
      @concrete = arg
      @root_calc()
      @abstract_calc()
      @name_calc()
      @prio_calc()
      @mother_calc()
      @degrees_calc()
    

    set_name: (arg) ->
      @name = arg
      @root = new PitchClass arg.split(' ')[0]
      @abstract= new AbstractMode arg.split(' ')[1]
      @concrete_calc()
      @prio_calc()
      @mother_calc()
      @degrees_calc()
    

    set_mother: (moth_name) ->
      if moth_name.split(' ').length == 1
        @abstract = new AbstractMode moth_name, @degree()
        @root= new PitchClass (@mother_root() + @abstract.moth_offset()) % 12
      else 	
        @abstract= new AbstractMode moth_name.split(' ')[1], @degree()
        @root= new PitchClass (MK.PITCHES[moth_name.split(' ')[0]] + @abstract.moth_offset()) % 12
      @concrete_calc()
      @prio_calc()
      @mother_calc()
      @name_calc()
      @degrees_calc()

    set_prio: (arr) ->

      pr = @prio.slice 0
      new_prio = []

      #check if each elem of arr is included in current mode
      #and if yes prepend to prio
      for el, i in arr
        index = pr.indexOf(el)
        if index >= 0
          new_prio.push el
          pr.splice(index,1)
      for el in pr
        new_prio.push el

      @prio = new_prio  

 #    #*********************************************************************

    intra_rel_move: (n) ->
      @set_concrete(_a.rotate(@concrete,n))

    intra_abs_move: (n) ->
      @set_concrete(_a.rotate( @concrete, (n-1)-(@degree()-1) )) 

    relative: (mode_name_str) ->
      for k,v of MK.MOTHERS
        if v.degrees.indexOf(mode_name_str) >= 0
          @abstract = new AbstractMode k, (v.degrees.indexOf mode_name_str)+1 
          @set_root(new PitchClass (@mother.root + @abstract.moth_offset())%12)
      @set_mother(new AbstractMode(mode_name_str).mother.name )
      @

    transpose: (n) ->
      @set_root(new PitchClass((@root.int + n + 12) % 12))
      @

    mother_struct_link: ->
      for x in all_moth_funct_struct(@concrete.length) #not yet ported
        if i = @concrete.is_transposition_of(x)
          return [x,i] 

 #    #************************ UTILS **************************************
    
    mother_root: ->
      (@root.int - @abstract.moth_offset() + 12 )%12

    degree: ->
      @abstract.degree

    clone: ->
      new Mode 
        name: @name 
        prio: @prio

    mother_mode: ->
      new Mode @mother.name

    degree_int: (degree) ->
      (degree.dist + @root.int) %12

    # def partials arg=(2..6), include_root=true #Fixnum or Range, root boolean

    # 	f=abstract.functs.dup
    # 	f.shift unless include_root

    # 	if arg.is_a? Range

    # 		results=Hash.new
    # 		arg.each {|x| results[x]=f.combination(x).to_a.
    # 			map {|xx| [xx,partial_prio_calc(xx)]}.sort_by(&:last).reverse}			
    # 	else
    # 		results=f.combination(arg).to_a.
    # 		map {|xx| [xx,partial_prio_calc(xx)]}.sort_by(&:last).reverse
    # 	end
    # 	results
    # end	

    # @@prio_rating_ratio=Rational 1,2
    # def partial_prio_calc partial
    # 	rates=(0..6).to_a.map {|x| x*@@prio_rating_ratio}.zip([0]+prio.reverse)
    # 	rates.select! {|x| partial.include? x[1]}.map!(&:first)
    # 	rates.inject(:+)
    # end	

