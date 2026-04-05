module OneZero

using Combinatorics
using DataFrames

function create_array(src)
    arr = []
    for (i, val) in enumerate(src)
        append!(arr, fill(i - 1, val))
    end
    return arr
end

function compute(target, max_base=3, max_digit=1)

    data_frame = DataFrame(
        [Vector{Union{Missing, Bool}}(missing, target) for _ in 1:(max_base - 2)], 
        [string(x) for x in 3:max_base]
    )

    for base in 3:max_base
        compute_for_base(data_frame, target, base, max_digit)
    end

    transform!(data_frame, AsTable(:) => ByRow(sum) => :row_sum)
    insertcols!(data_frame, 1, :id => 1:nrow(data_frame))

    df_subset = subset(data_frame, :row_sum => ByRow(>(2)))

    println(df_subset)
end

function compute_for_base(data_frame, target, base, max_digit=1)
    max_num_length = Int(floor(log(base, target)))
    powers = base .^ (0:max_num_length)

    combinations = []

    max_num_digits = max_digit + 1

    for partition_length in 1:max_num_digits
        fill_length = max_num_digits - partition_length

        for partition in Iterators.map(
            x -> fill_length > 0 ? vcat(x, fill(0, fill_length)) : x, 
            partitions(max_num_length + 1, partition_length)
        )
            append!(combinations, Iterators.map(
                create_array,
                multiset_permutations(partition)
            ))
        end
    end

    for combination in combinations
        for number in Iterators.map(
            perm -> sum(map(x -> powers[x[1]] * x[2], enumerate(perm))),
            multiset_permutations(combination)
        )
            if number in 1:target
                data_frame[number, base - 2] = true
            end
        end
    end

    data_frame[!, string(base)] = coalesce.(data_frame[!, string(base)], false)    
end

end # module OneZero
