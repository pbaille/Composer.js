define ["lib/GUI/elements/CycleButton", "vendors/ruby" ,"templates/RSelectTemplate"], ()->

  if typeof global != "undefined" && global != null 
    root= global.AC.GUI
  else
    root= window.AC.GUI 

  class root.RVS
    constructor: (opt) ->
      el = $(opt.el)
      el.addClass("rythmn_val_selector")
      el.html(window.JST['template_first'])
  
      buttons= el.find(".button")
      
      @generator = opt.generator 
      @table = opt.table || {4:1, 8:1}
      @sync_generator()

      @buttons = {}
  
      for b,i in buttons
        do (b,i) =>
          button_value = $(b).attr("value")
          @buttons[button_value] = new AC.GUI.CycleButton 
            mother: b
            items: ["","","",""]
            values: [0,1,2,3]
            colors: ["#423A38", "#BDB9B1" , "#47B8C8", "#D7503E"]
            current: 0
    
          #console.log @buttons[i]
          $(b).click () =>
            @table[button_value] = @buttons[button_value].get_val()
            @sync_generator()
      
      if @table
        @refresh_buttons()
      else  
        @set_table(RVS.default_table)

      @sync_generator()
      # @buttons[16].set_val(3)
  
      # @set_table
      #   2: 2
      #   7: 2
    @default_table =
      4: 1
  
    set_table: (obj) ->
      @table = obj
      #console.log @table
      @refresh_buttons()
  
    refresh_buttons: () ->
      for k,v of @table
        #console.log k
        #console.log v
        @buttons[k].set_val(v)

    sync_generator: () ->
      #console.log "sync"
      @generator.rvs_sync @table


  
  
  
  
  
    # console.log "hello"
    # window.cb = new PB.CycleButton
    #   mother: $("#rvs")
    #   items: ["","","",""]
    #   value: [0,1,2,3]
    #   colors: ["#423A38", "#E7EEE2" , "#47B8C8", "#D7503E"]
    #   current: 0
     