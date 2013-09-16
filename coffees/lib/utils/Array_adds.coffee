define ["vendors/ruby"], () ->


  Array::rotate = ( () ->
    unshift = Array::unshift
    splice = Array::splice
    (count) ->
      result = @slice(0) #copy
      len = result.length >>> 0
      count = count >> 0
      unshift.apply result, splice.call(result, count % len, len)
      result
  )()

  Array::rotations = ->
    result= []
    for x in [0..@length-1]
      result.push @rotate(x)
    _a.uniq(result)

  Array::median = ->
    @somme()/@length

  Array::somme = ->
    @reduce (previousValue, currentValue) ->
      return previousValue + currentValue

  Array::tonicize = ->
    result = @map (x) => ((x - @[0] + 12 ) % 12)
    _a.sort(result)

  Array::tonicized_rotations= ->
    @rotations().map (x) -> x.tonicize() 

  # don't change self
  Array::to_functs= ->
    @map (i) -> if i then i % 12 else i  

# Add the unique_permutation method to the Array class.
# This is incredibly more efficient that the built in permutation method as duplicate elements will yield
# identical permutations.

  # def unique_permutation(&block)
  #   return enum_for(:unique_permutation) unless block_given?

  #   array_copy = self.sort
  #   yield array_copy.dup
  #   return if size < 2

  #   while true
  #     # Based off of Algorithm L (Donald Knuth)
  #     j = size - 2;
  #     j -= 1 while j > 0 && array_copy[j] >= array_copy[j+1]

  #     if array_copy[j] < array_copy[j+1]
  #       l = size - 1
  #       l -= 1 while array_copy[j] >= array_copy[l] 

  #       array_copy[j] , array_copy[l] = array_copy[l] , array_copy[j]
  #       array_copy[j+1..-1] = array_copy[j+1..-1].reverse

  #       yield array_copy.dup

  #     else
  #       break
  #     end
  #   end
  # end

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


