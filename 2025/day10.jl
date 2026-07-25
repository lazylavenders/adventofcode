#!/usr/bin/julia
using Combinatorics:combinations

const rawinput::String = "[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}";
const input = split.(split(rawinput, '\n'), ' ')

function get_goal(base::Array, index::Int)::Vector{Int}
	map(base[index][begin][2:end-1] |> collect) do x
		x == '#' ? 1 : 0
	end
end

function get_buttons(base::Array, index::Int)::Vector{Vector{Int}}
	map(base[index][2:end-1]) do x
		parse.(Int, split(x[2:end-1], ','))
	end
end

function get_joltage(base::Array, index::Int)::Array{Int}
	parse.(Int, split(base[index][end][2:end-1], ','))
end

function get_bool(lights::Array)
	map(lights) do x 
		isodd(x) ? 1 : 0 
	end
end

function get_init(input, index)
	zeros(Int, length(input[index][begin]) - 2)
end

function do_button(state::Array{Int}, button::Array{Int})::Array{Int}
	state[button .+ 1] .+= 1
	return state
end

function do_buttons(state::Array{Int}, buttons...)
	for i in buttons
		state[i .+ 1] .+= 1
	end
	return state
end

function solve_row(input::Array, index::Int)	
	combos = collect(combinations(get_buttons(input, index)))
	#display(combos)
	magikarp = filter(combos) do x
		get_bool(do_buttons(get_init(input, index), x...)) == get_bool(get_goal(input, index))
	end 
	#@assert !isempty(magikarp) "No suitable solution found"
	minimum(length, magikarp)
end

#################################
#### TESTING STUFF
#################################
"@time begin
	display( get_buttons(input, 3))
	display( get_goal(input, 1))
### THEY WORK WELL
end"

#@time res = [solve_row(input, i) for i in 1:length(input)] |> sum

#println("The answer for part 1 is $res") # runs under a second!!!!!

function get_joltages(input::Array, index::Int)
	return parse.(Int, split(input[index][end][2:end-1], ','))
end

function get_matrix(input::Array, index::Int)::Matrix{Int}
	ref = input[index]
	side = length(ref[begin][2:end-1])
	resmatrix = zeros(Int, side, length(input[index]) -2)
	buttons = get_buttons(input, index)
	display(buttons); println(side)
	for i in 1:length(buttons)
		resmatrix[:, i] = do_button(get_init(input, index), buttons[i])
	end

	return resmatrix
end
function valid_combos(input::Array, index::Int)::Array
	combos = combinations(get_buttons(input, index)) |> collect
	filter(combos) do x
		get_bool(do_buttons(get_init(input, index), x...)) == get_bool(get_goal(input, index))
	end
end

function solve_row2(input::Array, index::Int)
	ref = input[index]
	res_matrix = get_matrix(input, index)

	valid_combos(input, index)
end

ind = 1


"display( solve_row2(input, ind))
display(get_goal(input, ind)')
display(get_joltages(input, ind)')"



#################################
#### The new recombinations code #
#################################
function patterns(coeffs::Vector{Vector{Int}})::Dict{Tuple, Int}
	out = Dict()
	numb = length(coeffs)
	display(coeffs)
	numv = coeffs[begin] |> length

	for pattern_len in 1:numb
		for buttons in combinations(1:(numb-1), pattern_len)
			pattern = vec(map(sum, zip(zeros(Int, numv), prod([coeffs[i] for i in buttons]))))
			if !in(pattern, out|>keys)
				out[pattern] = pattern_len
			end
		end
	end
	return out
end


function solve_single(coeffs::Vector, goal::Array)::Int
	pattern_costs = patterns(coeffs)


	function solve_single_aux(goal::Array)::Int
		if all((i == 0 for i in goal))
			return 0
		end

		answer = 1_000_000
		for (pattern, pattern_cost) in keys(patter_cost)
			if all((i<=j && i % 2 == j & 2 for (i, j) in zip(pattern, goal)))
				new_goal = tuple(floor((j - i)/2) for (i, j) in zip(pattern, goal))
				answer = min(answer, pattern_cost + 2 * solve_new_aux(new_goal))
			end

		end

		return answer
	end

	return solve_single_aux(goal)
end

function solve()
	answer = 0
	for i in 1:length(input)
		goal = get_goal(input, i)
		coeffs = get_buttons(input, i)

		subanswer = solve_single(coeffs, goal)
		println("$i   \t\t-> $(subanswer)")
		answer += subanswer
	end
	printstyled("\n\nAnswer is $answer", colour=:yellow)
end


solve()
