module JuliaQubit2

using PyCall
using TensorOperations

export JuliaQubit

qml = pyimport("pennylane")
devices_mod = pyimport("pennylane.devices")

@pydef mutable struct JuliaQubit <: devices_mod.DefaultQubit

    name = "Julia Qubit PennyLane plugin"
    short_name = "julia.qubit"
    pennylane_requires = "dev?"
    version = "0.0.1"
    author = "Christina Lee"

    operations = [
        "PauliX",
        "PauliY",
        "PauliZ",
        "Hadamard",
        "S",
        "T",
        "CNOT",
        "SWAP",
        "CSWAP",
        "Toffoli",
        "CZ",
        "PhaseShift",
        "RX",
        "RY",
        "RZ",
        "Rot",
        "CRX",
        "CRY",
        "CRZ",
        "CRot"
    ]

    observables = ["PauliX", "PauliY", "PauliZ", "Hadamard", "Identity"]

    function __init__(self, wires, args...; shots=None, cache=0)
            qml.devices.DefaultQubit.__init__(self, wires, shots=shots, cache=cache)
    end

    function apply_operation(self, state, op)
        dev_wires =  [self.wires_map[w] for w in op.wires]
        
        state_indices = -collect(1:self.num_wires)
        op_indices = cat(zeros(Int,length(op.wires)), (1:length(op.wires)), dims=1)

        for (i, w) in enumerate(reverse(dev_wires))
            state_indices[w]= i
            op_indices[i] = -w
        end

        matr = reshape(op.matrix, repeat([2], 2*op.wires.__len__())...)

        return ncon((matr, state), (op_indices, state_indices))
    end

    function apply(self, operations, args...; rotations=None, kwargs...)

        self._state = zeros(Complex{Float64}, repeat([2], self.num_wires)...)
        self._state[1] = 1.0

        self.wires_map = Dict(zip(self._wires, 1:self.num_wires))
        
        for op in operations
            self._state = self.apply_operation(self._state, op)
        end

        self._prerotated_state = self._state
    end

end

end
