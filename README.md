# TuringMachine

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `turing_machine` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:turing_machine, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/turing_machine](https://hexdocs.pm/turing_machine).

## Usage examples
Objective: delete every 1 except the last

```elixir
states =           
  %{}                                                 
  |> TuringMachine.build_state("A", "00RA 11RA __SB") 
  |> TuringMachine.build_state("B", "00SB 11S0 __LC") 
  |> TuringMachine.build_state("C", "00LC 11LD __LD") 
  |> TuringMachine.build_state("D", "00LD 1_LD __S0")                                               

tape = "0111"
TuringMachine.run(tape, states) # expected => "0__1"
```
