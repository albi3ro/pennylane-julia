module JuliaQubit

using PyCall
using TensorOperations

    function generate_state(n_wires::Int)::Array{Complex}
        return zeros(Complex{Float32}, repeat([2], n_wires)...)
    end

    function generate_wires_map(wires_class::PyObject)::Dict{Any, Int64}
        return Dict(zip(wires_class, 1:wires_class.__len__() ))
    end

    function apply(state::Array{Complex}, op::PyObject, wires_map::Dict{Any, Int64})::Array{Complex}
        dev_wires =  [wires_map[w] for w in op.wires]
        
        state_indices = -collect(1:n_wires)
        op_indices = cat(zeros(Int,length(op.wires)), (1:length(op.wires)), dims=1)

        for (i, w) in enumerate(reverse(dev_wires))
            state_indices[w]= i
            op_indices[i] = -w
        end
        
        return ncon((op.matrix, state), (op_indices, state_indices))
    end

    function apply_all(state::Array{Complex}, operations::Vector{PyObject}, wires_map)::Array{Complex}
        for op in operations
            state = apply(state, op, wires_map)
        end
        return state
    end

end