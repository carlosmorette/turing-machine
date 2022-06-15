defmodule TuringMachine do
  @valid_movements ["L", "R", "S"]

  def run(tape, _index, _states, "0"), do: tape

  def run(tape, index, states, state) do
    head = Enum.at(tape, index)
    instruction = states[state][head]

    if instruction do
      new_tape = List.update_at(tape, index, fn _ -> write(instruction) end)

      new_movement =
        instruction
        |> move()
        |> Kernel.+(index)

      run(new_tape, new_movement, states, state(instruction))
    else
      {:error, "State not found"}
    end
  end

  def write([value, _movement, _state]), do: value

  def move([_value, movement, _state]), do: move(movement)

  def move("R"), do: +1

  def move("L"), do: -1

  def move("S"), do: 0

  def state([_value, _movement, state]), do: state

  def build_state(name, string) do
    case build_instruction(string) do
      {:ok, i} -> %{name => i}
      {:error, error} -> {:error, error}
    end
  end

  def merge_states(states, new_state) do
    Map.merge(states, new_state)
  end

  def build_instruction(string) do
    instructions =
      string
      |> String.split("-")
      |> Enum.map(&String.split(&1, "", trim: true))

    if is_all_valid?(instructions) do
      {:ok, Enum.reduce(instructions, %{}, &reduce_fun/2)}
    else
      {:error, :invalid_format}
    end
  end

  def reduce_fun([key, w, m, s], acc) do
    Map.put(acc, key, [w, m, s])
  end

  def is_all_valid?(instructions) do
    Enum.all?(instructions, fn [_key, _w, m, _s] ->
      is_valid_movement?(m)
    end)
  end

  # left, right, stay
  def is_valid_movement?(m) when m in @valid_movements, do: true

  def is_valid_movement?(_), do: false
end
