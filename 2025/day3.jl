#!/usr/bin/julia
using Combinatorics: combinations as comb

input = "987654321111111
811111111111119
234234234234278
818181911112111"
num = Int[]
part= 2


function largestvoltage(bank; part=1, digits = 12, predata="", postdata="", debug = false)::String
	numberan = parse.(Int, split(bank, ""))

	if part == 1
		if count(x->x==maximum(numberan), numberan) > 1
			#println("this happened")
			return "$(maximum(numberan))"^2
		end
		maxnum = reverse(sort(numberan))[1:2]

		indexoflargest = findmax(numberan)[2]
		if indexoflargest < length(numberan)
			return "$(numberan[indexoflargest])$(maximum(numberan[indexoflargest+1:end]))"
		end
		return "$(maximum(numberan[begin:indexoflargest-1]))$(numberan[indexoflargest])"
	end
	
	
	#the part two is here
	if part == 2
		tnum = length(numberan)
		data = predata * ""
		
		head = findmax(numberan) #findmax(iterable) -> (max(x), index)
		debug && println(repr(head)) 

		if tnum == digits
			return predata*bank*postdata
		end
		if digits == 0
			return predata*postdata
		end
		if head[2] == tnum - digits + 1 # if the largest number is just the beginning of latter,
			# returns the entire latter
			return string(predata, bank[head[2]:end], postdata)
		end
		if head[2] < tnum - digits + 1 # if the largest number in the former part of the string
			debug && println(repr(bank), repr(head), repr(tnum), digits,"/")
			return largestvoltage(bank[head[2]+1:end];part=2, digits=digits-1,
				predata=string(predata,head[1]), postdata=postdata, debug = debug)
		end
		if head[2] > tnum - digits + 1 # if the largest number is in the latter part of the number
			l_former = findmax(numberan[begin:(end-digits + 1)])
			# NEXT TIME WORK HERE YAY # YESSS IT WORKS AYYYYY
			debug && println(repr(l_former),' ',numberan[begin:(end-digits)],
				' ',repr(bank),' ', digits, '[')
			return largestvoltage(bank[l_former[2]+1:end],part=2, digits=digits-1,
				predata=predata*string(l_former[1]), postdata=postdata, debug = debug)
		end

		return error("lmao idk")
		#return join(maxcollect(comb(numberan, digits))), "") grossly slow
	end
end



	for i in split(input, "\n")
		x = largestvoltage(i, part=part, debug=false)
		append!(num, parse.(Int,x))
		println(x, " we are here")
	end

	println("FINAL ANSWER = ",sum(num))
	#println("FINAL ANSWER = ", largestvoltage(input, part=part))



# YESSSSS IT WORKSSSS AYYYEEEEEE
	