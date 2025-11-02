# Problem's link: https://www.hackerrank.com/challenges/apple-and-orange/problem

def countApplesAndOranges(s, t, a, b, apples, oranges)
    applesOnHouse = 0
    orangesOnHouse = 0
    
    apples.each do |apple|
        
       if ( (apple + a) >= s and (apple + a) <= t )
            applesOnHouse += 1
       end
       
    end
    
    oranges.each do |orange|
       if ( (orange + b) <= t and (orange + b) >= s )
            orangesOnHouse += 1
       end
    end
    
    puts applesOnHouse
    puts orangesOnHouse
end
