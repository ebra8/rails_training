# Problem's link: https://www.hackerrank.com/challenges/between-two-sets/problem

def getTotalX(a, b)
    
    lcm = a.reduce(1) { |acc, n| acc.lcm(n) }
    gcd = b.reduce { |acc, n| acc.gcd(n) }

    count = 0
    
    (lcm..gcd).step(lcm) do |i|
        count += 1 if gcd % i == 0
    end

    count
end
