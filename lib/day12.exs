defmodule Day12 do
    def input do
        File.read!('lib/day12.txt')
        |> String.split("\n")
        |> Enum.slice(0..-2)
    end

    def test_input do
        File.read!('lib/day12-test.txt')
        |> String.split("\n")
        |> Enum.slice(0..-2)
    end

    def run_test do
        Assembunny.process_instructions test_input()
    end

    def run_part_one do
        Assembunny.process_instructions input()
    end
end

defmodule Assembunny do
    def blank do
        %{"a" => 0, "b" => 0, "c" => 0, "d" => 0}
    end

    def process_instructions(instructions) do
        process_instructions blank(), Enum.with_index(instructions), 0
    end

    def process_instructions(registers, instructions, index) when index < length(instructions) do
        {next_registers, next_index} = process_instruction registers, Enum.at(instructions, index)
        process_instructions next_registers, instructions, next_index
    end

    def process_instructions(registers, _instructions, _index) do
        registers
    end

    def process_instruction register, {instruction, index} do
        process_instruction register, index, String.split(instruction)
    end

    def process_instruction registers, index, ["inc", x] do
        {%{registers | x => registers[x] + 1}, index + 1}
    end

    def process_instruction registers, index, ["dec", x] do
        {%{registers | x => registers[x] -1}, index + 1}
    end

    def process_instruction registers, index, ["cpy", x, y] do
        with {int, _} <- Integer.parse(x) do
            {%{registers | y => int}, index + 1}
        else
            :error -> {%{registers | y => registers[x]}, index + 1}
        end
    end

    def process_instruction registers, index, ["jnz", x, y] do
        if registers[x] == 0 do
            {registers, index + 1}
        else
            {registers, index + String.to_integer(y)}
        end
    end

end
