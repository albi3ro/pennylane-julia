from pennylane import QubitDevice


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

    observables = {}

    def __init__(self, wires, *, shots=1000, cache=0):
        super().__init__(wires=wires, shots=shots)

        self.samples
        
    @classmethod
    def capabilities(cls):
        capabilities = super().capabilities.copy()
        capabilities.update(
            model="qubit",
            supports_finite_shots=False,
            supports_reversible_diff=False,
            supports_inversion_operations=True,
            supports_analytic_computation=True,
            returns_state=True,
            returns_probs=True
        )

    def apply(self, operations, **kwargs):
        """ creates self.state and modifies it
        Args:
            operations (list[~.Operation]): operation to apply to the device
        """
        pass

    def analytic_probability(self, wires=None):
        """ returns marginal probability

        Args:
            wires (Iterable[Number, str], Number, str, Wires):
            wires to return marginal probabilties for.  Wires not provided are traced out of the system

        Returns:
            List[float]: list of the probabilities
        """
        pass
