defmodule TuringMachineTest do
  use ExUnit.Case
  doctest TuringMachine

  describe "Increment the input number by 1" do
    def increment_instructions do
      %{}
      |> TuringMachine.build_state(
        "A",
        "00RA 11RA 22RA 33RA 44RA 55RA 66RA 77RA 88RA 99RA __LB"
      )
      |> TuringMachine.build_state(
        "B",
        "01L0 12L0 23L0 34L0 45L0 56L0 67L0 78L0 89L0 90LB _1L0"
      )
    end

    test "123" do
      assert TuringMachine.run("123", increment_instructions()) =~ "124"
    end

    test "59" do
      assert TuringMachine.run("59", increment_instructions()) =~ "60"
    end

    test "60" do
      assert TuringMachine.run("60", increment_instructions()) =~ "61"
    end

    test "299" do
      assert TuringMachine.run("299", increment_instructions()) =~ "300"
    end
  end

  describe "Delete every 1 except the last" do
    def instructions_delete_every_except_last do
      %{}
      |> TuringMachine.build_state("A", "00RA 11RA __SB")
      |> TuringMachine.build_state("B", "00SB 11S0 __LC")
      |> TuringMachine.build_state("C", "00LC 11LD __LD")
      |> TuringMachine.build_state("D", "00LD 1_LD __S0")
    end

    test "0111" do
      assert TuringMachine.run("0111", instructions_delete_every_except_last()) =~ "0__1"
    end

    test "10101010" do
      assert TuringMachine.run("10101010", instructions_delete_every_except_last()) =~ "_0_0_010"
    end

    test "0000" do
      assert TuringMachine.run("0000", instructions_delete_every_except_last()) =~ "0000"
    end

    test "1000001" do
      assert TuringMachine.run("1000001", instructions_delete_every_except_last()) =~ "_000001"
    end
  end
end
