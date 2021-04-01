import julia

jl = julia.Julia(compiled_modules=False)

from julia import Main

Main.include("./JuliaQubit.jl")

JuliaQubit = Main.JuliaQubit2.JuliaQubit