defmodule TuringMachine do
  def run(tape, states) do
    run(tape, 0, states, "A")
  end

  def run(tape, _index, _states, "0"), do: Enum.join(tape)

  def run(tape, index, states, state) when is_binary(tape) do
    tape
    |> to_list()
    |> run(index, states, state)
  end

  def run(tape, index, states, state) do
    if state_exists?(states, state) do
      extended_tape = extend_tape(tape, index)

      head = Enum.at(extended_tape, index)
      current_state = states[state]

      instruction = current_state[head]

      new_tape = List.update_at(extended_tape, index, fn _ -> write(instruction) end)

      new_index =
        instruction
        |> move()
        |> Kernel.+(index)

      run(new_tape, new_index, states, state(instruction))
    else
      {:error, "State not found"}
    end
  end

  def state_exists?(states, state) do
    Map.has_key?(states, state)
  end

  def extend_tape(tape, index) do
    tape_length = Enum.count(tape) - 1

    cond do
      index > tape_length ->
        tape ++ ["_"]

      index < 0 ->
        ["_"] ++ tape

      true ->
        tape
    end
  end

  def to_list(string) do
    String.split(string, "", trim: true)
  end

  def write([value, _movement, _state]), do: value

  def move([_value, movement, _state]), do: move(movement)

  def move("R"), do: +1

  def move("L"), do: -1

  def move("S"), do: 0

  def state([_value, _movement, state]), do: state

  def build_state(preview_state, name, string) when is_map(preview_state) do
    case build_instruction(string) do
      {:ok, i} -> merge_states(preview_state, %{name => i})
      {:error, error} -> {:error, error}
    end
  end

  def build_instruction(string) do
    instructions =
      string
      |> String.split(" ")
      |> Enum.map(&String.split(&1, "", trim: true))

    if is_all_valid?(instructions) do
      {:ok, Enum.reduce(instructions, %{}, &reduce_fun/2)}
    else
      {:error, :invalid_format}
    end
  end

  # key, write, move, state
  def reduce_fun([key, w, m, s], acc) do
    Map.put(acc, key, [w, m, s])
  end

  # left, rigth, stay
  @valid_movements ["L", "R", "S"]

  def is_all_valid?(instructions) do
    Enum.all?(instructions, fn [_key, _w, m, _s] ->
      m in @valid_movements
    end)
  end

  def merge_states(state_a, state_b) do
    Map.merge(state_a, state_b)
  end
end
