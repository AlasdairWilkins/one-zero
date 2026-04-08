module Inexhaustible

using Base.Iterators

function get_next_number(digit_range, current_number=[0])
    if first(current_number) != last(digit_range)
        current_number[1] += 1
        return current_number
    end

    if length(current_number) == 1
        return [0, 1]
    end

    return vcat([0], get_next_number(digit_range, current_number[2:end]))
end

function compute_initial_number(base, number, output=[])
    if number == 0
        return isempty(output) ? [0] : output
    end

    power = Int(floor(log(base, number)))

    if isempty(output)
        output = fill(0, power+1)
    end

    quotient, remainder = divrem(number, base^power)

    output[power+1] = quotient

    return compute_initial_number(base, remainder, output)
end

function inexhaustible_generator(pseudo_base, bases, start, finish=nothing)

    if isnothing(finish)
        finish = start
        start = 0 
    end

    digits = 0:pseudo_base-1
    if first(bases) <= pseudo_base
        error("All bases must be greater than pseudo base")
    end

    max_powers = map(base -> Int(floor(log(base, finish))), bases)
    powers = map(enumerate(max_powers)) do (index, max_power)
        bases[index] .^ (0:max_power)
    end

    initial_value = compute_initial_number(pseudo_base, start)
    println(initial_value)

    next_number = get_next_number(
        digits, 
        initial_value,
    )

    println(next_number)

    # Get next number
    # Store powers -- most efficient way to do this???
    # Multiply out

    # takewhile(get_next_number)

    # channel = Channel() do ch

    #     while true

    #         if(length(ch) == 0) 
    #             println("exhausted")
    #             append!()
    #         end
    #         put!(ch, a)
    #         a, b = b, a + b
    #     end
    # end
end

end