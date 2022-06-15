defmodule TuringMachine do
  def move("R"), do: +1

  def move("L"), do: -1

  def move("S"), do: 0

  def run(tape, _index, _states, "S"), do: tape

  def run(tape, index, states, state \\ "A") do
    head = Enum.at(tape, index)
    instruction = states[state][head]

    new_tape = List.update_at(tape, index, fn _ -> Enum.at(instruction, 0) end)

    new_movement =
      instruction
      |> Enum.at(1)
      |> move()
      |> Kernel.+(index)

    new_state = Enum.at(instruction, 2)

    run(new_tape, new_movement, states, new_state)
  end
end
