class RVS
  constructor: (opt) ->
    el = $(opt.el)
    el.addClass("rythmn_val_selector")
    el.html(window.JST['template_first'])

    buttons= el.find(".button")
    @buttons = {}
    @table = {}

    for b,i in buttons
      do (b,i) =>
        button_value = $(b).attr("value")
        @buttons[button_value] = new PB.CycleButton 
          mother: b
          items: ["","","",""]
          values: [0,1,2,3]
          colors: ["#423A38", "#BDB9B1" , "#47B8C8", "#D7503E"]
          current: 0
  
        console.log @buttons[i]
        $(b).click () =>
          @table[button_value] = @buttons[button_value].get_val()

    @buttons[16].set_val(3)

    @set_table
      2: 2
      7: 2

  set_table: (obj) ->
    @table = obj
    console.log @table
    @refresh_buttons()

  refresh_buttons: () ->
    for k,v of @table
      console.log k
      console.log v
      @buttons[k].set_val(v)



jQuery ($) ->

  window.rvs = new RVS 
    el: "#rvs"
    

  # console.log "hello"
  # window.cb = new PB.CycleButton
  #   mother: $("#rvs")
  #   items: ["","","",""]
  #   value: [0,1,2,3]
  #   colors: ["#423A38", "#E7EEE2" , "#47B8C8", "#D7503E"]
  #   current: 0
 