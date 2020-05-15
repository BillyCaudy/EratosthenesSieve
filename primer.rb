require 'byebug'
include Math

n = 10_000_000

def eratosthenes_sieve(n = 1)
    start_time = Time.now.to_f
    if !n.is_a?(Integer) || n < 1
        runtime = Time.now.to_f - start_time
        puts "there is no #{n}th prime, runtime = #{runtime}s" 
        return []
    end
    start_time = Time.now.to_f
    primes = [2]
    if n == 1
        runtime = Time.now.to_f - start_time
        puts "the #{n}th prime is #{ith_prime}, runtime = #{runtime}s" 
        return primes
    end
    high_estimate = n*log(n*log(n)).to_i
    high_estimate -= 1 if high_estimate.even?
    # high_estimate -= 2 if high_estimate % 3 == 0
    relative_primes = [] 
    # relatively prime to those in primes[]
    i = 3
    while i <= high_estimate
        relative_primes << i  
        i += 2 # value = 2 * index + 3
    end
    first_index = 0
    last_index = relative_primes.length - 1
    while relative_primes[first_index]**2 <= relative_primes[last_index]
        # debugger
        index = first_index
        next_prime = ( 2 * index + 3 )
        primes << next_prime
        while index <= last_index
            relative_primes[index] = nil
            index += next_prime
        end
        first_index += 1 until relative_primes[first_index]
        last_index -= 1 until relative_primes[last_index]
    end
    primes += relative_primes.select { |num| num }
    runtime = Time.now.to_f - start_time
    puts "\nthe #{n}th prime is #{primes[n-1]}, runtime = #{runtime}s" 
    print "\nhigh estimate = #{high_estimate}, "
    return primes
end

def nth_prime(n = 1)
    start_time = Time.now.to_f
    if !n.is_a?(Integer) || n < 1
        runtime = Time.now.to_f - start_time
        puts "there is no #{n}th prime, runtime = #{runtime}s" 
        return []
    end
    start_time = Time.now.to_f
    primes = []
    ith_prime = 2
    i = 1
    primes << ith_prime
    if i == n 
        runtime = Time.now.to_f - start_time
        puts "the #{n}th prime is #{ith_prime}, runtime = #{runtime}s" 
        return primes
    end
    ith_prime = 3
    ith_sqirt = 1
    i = 2
    primes << ith_prime
    while i < n
        # iter_time = Time.now.to_f
        next_prime = ith_prime + 2
        next_sqirt = floorsqirt(next_prime, ith_sqirt)
        until prime?(next_prime, primes, next_sqirt)
            next_prime += 2 
            next_sqirt = floorsqirt(next_prime, next_sqirt)
        end
        ith_prime = next_prime
        ith_sqirt = next_sqirt
        i += 1
        primes << ith_prime
        # if i % 1000 == 0 && i <= n - 1000
        #     puts "#{i}th iteration complete in #{Time.now.to_f - iter_time}"
        # end
    end
    runtime = Time.now.to_f - start_time
    puts "the #{n}th prime is #{ith_prime}, runtime = #{runtime}s" if i == n #should always be true
    return primes #runtime #ith_prime
end

def prime?(num, primes, sqirt)
    return false if num < 2
    i = 0
    div = primes[i]
    while div <= sqirt 
        return false if num % div == 0 
        i += 1
        div = primes[i] 
    end
    true
end

def floorsqirt(num, sqirt = 1)
    sqirt += 1 until (sqirt+1)**2 > num 
    sqirt
end

# ---- ---  --   -    -       -
# beta version of nth_primes
# ---- ---  --   -    -       -

def beta_nth_prime (n = 1)
    start_time = Time.now.to_f
    if !n.is_a?(Integer) || n < 1
        runtime = Time.now.to_f - start_time
        puts "there is no #{n}th prime, runtime = #{runtime}s" 
        return runtime
    end
    start_time = Time.now.to_f
    ith_prime = 2
    i = 1
    if i == n 
        runtime = Time.now.to_f - start_time
        puts "the #{n}th prime is #{ith_prime}, runtime = #{runtime}s" 
        return runtime
    end
    ith_prime = 3
    ith_sqirt = 1
    i = 2
    while i < n
        # iter_time = Time.now.to_f
        next_prime = ith_prime + 2
        next_sqirt = beta_floorsqirt(next_prime,ith_sqirt)
        until beta_prime?(next_prime,next_sqirt)
            next_prime += 2 
            next_sqirt = beta_floorsqirt(next_prime,next_sqirt)
        end
        ith_prime = next_prime
        ith_sqirt = next_sqirt
        i += 1
        # if i % 1000 == 0 && i <= n - 1000
        #     puts "#{i}th iteration complete in #{Time.now.to_f - iter_time}"
        # end
    end
    runtime = Time.now.to_f - start_time
    puts "the #{n}th prime is #{ith_prime}, runtime = #{runtime}s" if i == n #should always be true
    return runtime #ith_prime
end

def beta_prime?(i, sqirt)
    return true if i == 2
    return false if i % 2 == 0
    div = 3
    while div <= sqirt 
        return false if i % div == 0 
        div += 2
    end
    true
end

def beta_floorsqirt(i, sqirt = 1)
    sqirt += 1 until (sqirt+1)**2 > i 
    sqirt
end

# ---- ---  --   -    -       -
# my math methods: avg, sds, sdm
# ---- ---  --   -    -       -

def avg(sample)
    sample.inject{ |sum, trial| sum + trial }.to_f / sample.size 
end

def sds(sample)
    averg = avg(sample)
    sqrt( ( sample.inject(0.0) do |sum, trial| 
        
        # debugger
        sum + ( trial**2 - averg**2 ).abs 
        
    end).to_f / ( sample.size - 1.0 ) )
end

# nth_prime n

primes = eratosthenes_sieve n

# this all? call takes a long time
# all_prime = primes.all? { |num| beta_prime?(num,floorsqirt(num)) } 
# puts "all prime? = #{all_prime}"

puts "the #{primes.length}th prime is #{primes.last}\n\n" 

# puts "   "
# nth_prime 0
# nth_prime 1
# nth_prime 2
# nth_prime 3
# nth_prime 4
# nth_prime 5
# nth_prime 10 
# nth_prime 100
# nth_prime 1000
# nth_prime 10000
# thenthprime = 100_000
# primes = nth_prime thenthprime

# numdatapoints = 1000
# printevery = thenthprime/numdatapoints
# open('dataprimes.txt', 'w') do |f|
#     f.puts "n\tπ"
#     i = printevery - 1
#     while i < thenthprime
#         f.puts "#{i+1}\t#{primes[i]}"
#         i += printevery
#     end
# end

# i = 10
# while i >= 0 
#     p primes[(-1-100000*i)]
#     p primes[0..(-1-100000*i)].inject(1) { |a,e| 1.0*a*(e-1)/e}
#     i -= 1
# end

# nth_prime 1000000
# nth_prime 1000000#0

# puts beta_nth_prime(1000)
# puts beta_nth_prime(1999)
# puts beta_nth_prime(2000)
            
# def sdm(sample)
#     sds(sample) / sqrt( sample.size )
# end

# runtimes = []
# i = 0
# 100.times do 
#     puts "    -       -   --  --- trial: #{i += 1} ---  --   -       - "
#     runtimes << nth_prime(1000000)  
# end
# p avg(runtimes)
# p sdm(runtimes)

millionthprimeruntimes = [
    73.95240688323975,
    74.89107704162598,
    76.2344319820404,
    75.90490221977234,
    73.37643194198608,
    73.57988929748535,
    73.25391006469727,
    73.40153908729553,
    73.2429130077362,
    73.24043393135071,
    73.3631501197815,
    74.0595531463623,
    74.93503594398499,
    74.21265888214111,
    74.34314227104187,
    74.34171319007874,
    74.82721400260925,
    74.90793299674988,
    77.41120505332947,
    74.84296822547913,
    73.87397789955139,
    73.76650905609131,
    73.79213619232178,
    73.87187623977661,
    74.05218267440796,
    75.40784215927124,
    75.7103168964386,
    73.39082384109497,
    73.25845408439636,
    73.54683804512024,
    73.3979561328888,
    73.37306904792786,
    73.2564480304718,
    73.29147601127625,
    73.2976701259613,
    73.31793808937073,
    73.30001997947693,
    73.48792695999146,
    73.41243624687195,
    73.18669414520264,
    73.31140303611755,
    73.29892373085022,
    73.39127612113953,
    73.35569524765015,
    73.50048685073853,
    73.25125479698181,
    73.39457774162292,
    73.57778787612915,
    73.34457278251648,
    73.40503096580505,
    73.34500217437744,
    73.42824101448059,
    73.33754587173462,
    73.37667298316956,
    73.39013385772705,
    73.2980170249939,
    73.2093391418457,
    73.3511118888855,
    73.31280899047852,
    73.34739923477173,
    77.07503199577332,
    73.9878888130188,
    74.03031587600708,
    73.47178602218628,
    74.20690727233887,
    76.66263604164124,
    73.22053098678589,
    73.41196417808533,
    73.17818427085876,
    73.0602719783783,
    73.11193513870239,
    73.12840604782104,
    73.00338125228882,
    73.13507008552551,
    73.14288783073425,
    73.13993120193481,
    73.0432436466217,
    73.27242922782898,
    73.14046120643616,
    73.62965726852417,
    73.90345311164856,
    73.19319295883179,
    73.2978630065918,
    73.22337794303894,
    73.22471117973328,
    73.1148829460144,
    73.04089093208313,
    73.07351088523865,
    73.12805199623108,
    73.13570618629456,
    73.2544813156128,
    73.16149997711182,
    73.07866787910461,
    73.18114399909973,
    73.0641028881073,
    73.134526014328,
    73.0469229221344,
    75.30760097503662,
    74.84830117225647,
    75.51130700111389,
    75.95018696784973
]
# p avg(millionthprimeruntimes)
# p sdm(millionthprimeruntimes)
