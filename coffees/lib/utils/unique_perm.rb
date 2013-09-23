class Array
  def unique_permutation(&block)
    #return enum_for(:unique_permutation) unless block_given?

    array_copy = self.sort
    yield array_copy.dup
    return if size < 2

    while true
      # Based off of Algorithm L (Donald Knuth)
      j = size - 2;
      j -= 1 while j > 0 && array_copy[j] >= array_copy[j+1]

      if array_copy[j] < array_copy[j+1]
        l = size - 1
        l -= 1 while array_copy[j] >= array_copy[l] 

        array_copy[j] , array_copy[l] = array_copy[l] , array_copy[j]
        array_copy[j+1..-1] = array_copy[j+1..-1].reverse

        yield array_copy.dup

      else
        break
      end
    end
  end
end  

[1,2,3,1].unique_permutation {|x| p x}
