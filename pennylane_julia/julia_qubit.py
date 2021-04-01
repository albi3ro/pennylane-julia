from pennylane.devices import DefaultQubit
import julia

jl = julia.Julia(compiled_modules=False)

from julia import Main
Main.include('JuliaQubit.jl')

class JuliaQubit(DefaultQubit):
    """ PennyLane Julia deivce.


    Args:
        wires (int): the number of wires to initialize the device with
        shots (int): Currently not applicable
        cache (int): currently not applicable
    """

    name = "Julia Qubit PennyLane plugin"
    short_name = "julia.qubit"
    pennylane_requires = "dev?"
    version = "0.0.1"
    author = "Xanadu Inc. : Christina Lee"

    operations = {
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
    }

    observables = {"PauliX", "PauliY", "PauliZ", "Hadamard", "Identity"}

    def __init__(self, wires, *, shots=1000, cache=0):
        super().__init__(wires=wires, shots=shots)
        
    @classmethod
    def capabilities(cls):
        capabilities = super().capabilities().copy()
        capabilities.update(
            model="qubit",
            supports_reversible_diff=False,
            supports_inverse_operations=False,
            supports_analytic_computation=True,
            returns_state=True,
        )
        capabilities.pop("passthru_devices", None)
        return capabilities

    def apply(self, operations, rotations=None,**kwargs):
        """ creates self.state and modifies it
        Args:
            operations (list[~.Operation]): operation to apply to the device
        """
        self._state = Main.JuliaQubit.apply_all(self._wires, operations)

        # store the pre-rotated state
        self._pre_rotated_state = self._state

        #Main.JuliaQubit.apply(self._state, )

    #def analytic_probability(self, wires=None):
        """ returns marginal probability

        Args:
            wires (Iterable[Number, str], Number, str, Wires):
            wires to return marginal probabilties for.  Wires not provided are traced out of the system

        Returns:
            List[float]: list of the probabilities
        """
    #   pass
