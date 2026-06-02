#!/usr/bin/julia
inputargs = "269351-363914,180-254,79-106,771-1061,4780775-4976839,7568-10237,33329-46781,127083410-127183480,19624-26384,9393862801-9393974421,2144-3002,922397-1093053,39-55,2173488366-2173540399,879765-909760,85099621-85259580,2-16,796214-878478,163241-234234,93853262-94049189,416472-519164,77197-98043,17-27,88534636-88694588,57-76,193139610-193243344,53458904-53583295,4674629752-4674660925,4423378-4482184,570401-735018,280-392,4545446473-4545461510,462-664,5092-7032,26156828-26366132,10296-12941,61640-74898,7171671518-7171766360,3433355031-3433496616"
inv_id = []
#req = r"[0-9]{2,}"


function inv_id_check(val::Integer)
	sval = string(val)
	l = length(sval)
	midp = ceil(l//2)


	for i::Integer ∈ 1:midp
		huh = sval[begin:i]^(l÷i)
		if sval == huh
			return true
		end
	end
	return false
end

for i in split(inputargs, ',')
	a, b = parse.(Int, split(i, '-'))

	#print("$a - $b\n")
	for j = a : b
		q = string(j)
		w = length(q)
		#println("q -> $q, w -> $w, $(q[1 : round(Integer,w//2)]), $(q[(round(Integer,w//2) +1)])")
		"""if iseven(w)
									if q[1 : round(Integer,w//2)] == q[(round(Integer,w//2) +1) : end]
										global inv_id = vcat(inv_id, j)
									end
								end"""
		#Now we use the regex method for this, ayyy
		#No we don't
		f = inv_id_check(j)
		if f
			push!(inv_id, j)
			println(j)
		end
	end
end

#println(repr(inv_id))
println(sum(inv_id))