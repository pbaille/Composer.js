define ["vendors/ruby"], () ->


  #wrap any object in an array if it is not an array
  _a.wrap_if_not= (arr) ->
    arr = [arr] unless arr instanceof Array 
    return arr

  _a.pick_random_el= (arr) ->
    rand_index = Math.floor(Math.random()*(arr.length))
    return arr[rand_index]
  
  _a.scramble = (arr) ->
    counter = arr.length
    temp= undefined
    index= undefined

    #While there are elements in the arr
    while counter-- 
      #Pick a random index
      index = (Math.random() * (counter + 1)) | 0

      #And swap the last element with it
      temp = arr[counter]
      arr[counter] = arr[index]
      arr[index] = temp

    return arr
  ############ RubyJS.Array adds (functional style) ##########

  #already implemented in rubyjs , maybe remove it... but fear of a break
  # _a.rotate = ( () ->
  #   unshift = Array::unshift
  #   splice = Array::splice
  #   (arr,count) ->
  #     result = arr.slice(0) #copy
  #     len = result.length >>> 0
  #     count = count >> 0
  #     unshift.apply result, splice.call(result, count % len, len)
  #     result
  # )()

  _a.rotations = (arr) ->
    result= []
    for x in [0..arr.length-1]
      result.push _a.rotate(arr,x)
    _a.uniq(result)

  _a.median = (arr) ->
    _a.somme(arr)/arr.length

  _a.somme = (arr)->
    arr.reduce (previousValue, currentValue) ->
      return previousValue + currentValue

  _a.tonicize = (arr) ->
    result = arr.map (x) => ((x - arr[0] + 12 ) % 12)
    _a.sort(result)

  _a.tonicized_rotations= (arr) ->
    _a.rotations(arr).map (x) -> _a.tonicize(x) 

  # don't change self
  _a.to_functs= (arr) ->
    arr.map (i) -> if i then i % 12 else i  

  ########## Combinatorics #########

  RubyJS.Array.prototype.unique_permutation = () ->

    array_copy = @sort()
    results = []
    results.push array_copy.dup().value()
    return if @size() < 2

    while true
      # Based off of Algorithm L (Donald Knuth)
      j = @size() - 2

      j -= 1 while j > 0 and array_copy.get(j) >= array_copy.get(j+1)

      if array_copy.get(j) < array_copy.get(j+1)
        l = @size() - 1

        l -= 1 while array_copy.get(j) >= array_copy.get(l)

        temp = array_copy.get(j)
        array_copy.set(j,array_copy.get(l))
        array_copy.set(l,temp)

        rev = array_copy.dup().reverse()
        range = [j+1..@size()-1]
        
        for e, i in range
          array_copy.set(e,rev.get(i))

        results.push array_copy.dup().value()

      else
        break

    return results

  _a.statusCombination= (arr) ->
    #a=int[] (maxVal of each slot)
    # Caution!!! values from 0! 1=> 2 status (0,1)

    result = []
    temp = []
    # debugger
    for x in arr
      result = []
      if temp.length == 0
        result.push [i] for i in [0..x]
      else
        for int in [0..x]
          for item in temp
            it = item.concat int
            result.push it
      temp= result[..]

    return result    
  
  _a.comb_zip= (a) ->

    results= []
    status_tab= a.map (x) -> x.length-1
  
    for x in _a.statusCombination(status_tab)
      results.push x.map (y,i) -> a[i][y]
    return results


#   def unique_permutation_no_rot
#     results=[]
#     self.unique_permutation.to_a.each do |w|
#       results<<w unless results.any? {|y| w.rotations.any? {|z| y==z}}
#     end
#     results
#   end 

#   def has_b9? #ordering is important !! for basic pitches use please ensure the chord is sorted
#     result=nil
#     each_with_index do |x,i|
#       last(size-(i+1)).each do |y|
#       if (y-x)%12==1 and y-x!=1 and self[i+1]!=self[i]+1
#         result||=[]; result<<[x,y]  
#       end  
#       end 
#     end
#     result || false
#   end 

#   #******************* functs_module(to wrap) *************************
  
#   def intervals_to_functs
#     [0]+self.each_with_index.map{|x,i| self.first(i+1).inject(:+)%12}
#   end

#   def functs_to_chord
#     result=Array.new(self)
#     (1..result.size-1).each do |x|
#       if result[x-1]>result[x]
#         (x..result.size-1).each {|y| result[y]+=12}
#       end
#     end  
#     result    
#   end 

#   #return false or rotation index
#   def is_tonicized_rotation_of? arr
#     tr=arr.tonicized_rotations
#     if tr.include? self.sort then tr.index self.sort
#     else false end
#   end

#   def transpositions
#     results=[]
#     (0..11).each {|y| results<<self.transposed_by(y)}
#     results
#   end

#   def transposed_by t 
#     self.map {|x| (x+t)%12}.sort
#   end 

#   #return false or transposition_offset
#   def is_transposition_of? arr
#     trans=arr.transpositions
#     if trans.include? self.sort then trans.index self.sort
#     else false end  
#   end

#   def inter_tab
#     Array.new(self.size-1) {|x| self[x+1]-self[x]}
#   end

#   def find_mothers
#     results=[]
#     MOTHERS.each do |k,v|
#       temp=[]
#       v[:functs].tonicized_rotations.each_with_index do |y,i|
#         if self.tonicize.all? {|x| y.include? x}
#           temp<<k unless temp.include? k 
#           temp<<i+1 # +1 to symbolize degree
#         end
#       end
#       results<<temp
#     end 
#     results.select {|x| !x.empty?} 
#   end

#   def find_modes
#     results=[]
#     self.find_mothers.each do |x|
#       x.last(x.size-1).each {|y| results<<MOTHERS[x[0]][:degrees][y-1]}
#     end  
#     results
#   end 

#   def fits_known_mother
#     all_lyd_mothers.values.each do |x|
#       return true if x.tonicized_rotations.any? {|y| self.tonicize.all? {|z| y.include?(z)}}
#     end
#     false 
#   end

#   def fits_basic_mother
#     MOTHERS.each do |x,v|
#       return true if v[:functs].tonicized_rotations.any? {|y| self.tonicize.all? {|z| y.include?(z)}}
#     end
#     false  
#   end 

#   #***********************************************************

# end


