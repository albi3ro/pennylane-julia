module JuliaQubit

using PyCall
using TensorOperations

export apply_all

    function generate_wires_map(wires_class)
        return Dict(zip(wires_class, 1:wires_class.__len__() ))
    end

    function apply(state, op, wires_map, n_wires)
        dev_wires =  [wires_map[w] for w in op.wires]
        
        state_indices = -collect(1:n_wires)
        op_indices = cat(zeros(Int,length(op.wires)), (1:length(op.wires)), dims=1)

        for (i, w) in enumerate(reverse(dev_wires))
            state_indices[w]= i
            op_indices[i] = -w
        end

        matr = reshape(op.matrix, repeat([2], 2*op.wires.__len__())...)

        return ncon((matr, state), (op_indices, state_indices))
    end

    function apply_all(wires_class, operations)

        n_wires = wires_class.__len__()
        state = zeros(Complex{Float32}, repeat([2], n_wires)...)
        state[1] = 1

        wires_map = generate_wires_map(wires_class)
        
        for op in operations
            state = apply(state, op, wires_map, n_wires)
        end
        return state
    end

end