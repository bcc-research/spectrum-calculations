using SparseArrays
using LinearAlgebra
using Combinatorics

function compute_complete(max_vals=7)
    println("Complete graph coherence")
    for n in 2:max_vals
        N = factorial(n)
        μ = sqrt(1-1/N)

        println("n=$n: $μ")
    end
end

function compute_transpose(max_vals=7)
    println("Transpose graph coherence")
    for n in 2:max_vals
        p = collect(permutations(1:n))

        I = Vector{Int64}()
        J = Vector{Int64}()

        for (i, p_i) in enumerate(p)
            for (j, p_j) in enumerate(@views p[i+1:end])
                count = 0
                for (k,l) in zip(p_i, p_j)
                    if k != l
                        count += 1
                    end

                    if count > 2
                        # Not a transposition, break out of the larger loop
                        @goto not_transposition
                    end
                end
                push!(I, i)
                push!(J, j+i)

                @label not_transposition
            end
        end

        N = factorial(n)
        A = Symmetric(Matrix(sparse(I, J, 1, N, N)))
        μ = maximum(abs.(eigvecs(A)))
        println("n=$n: $μ")
    end
end

compute_complete()
println("\n")
compute_transpose()
