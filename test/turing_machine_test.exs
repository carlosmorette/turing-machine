defmodule TuringMachineTest do
  use ExUnit.Case
  doctest TuringMachine

  test "greets the world" do
    assert TuringMachine.hello() == :world
  end
end
