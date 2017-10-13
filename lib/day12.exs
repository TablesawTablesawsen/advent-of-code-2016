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

    def run_part_two do
        registers = %{Assembunny.blank | "c" => 1}
        indexed_instructions = input() |> Enum.with_index
        Assembunny.process_instructions registers, indexed_instructions, 0
    end

    def fibonacci(1), do: 1
    def fibonacci(2), do: 1
    def fibonacci(n), do: fibonacci(n-1) + fibonacci(n-2)

    def modern_assembunny(c) do
        # cpy 1 a
        # Seed for fibonacci series

        # cpy 1 b
        # Seed for fibonacci series

        # cpy 26 d
        d = 26

        # jnz c 2
        # jnz 1 5
        d = if c != 0 do
            # cpy 7 c
            # inc d
            # dec c
            # jnz c -2
            d + 7
        else
            d
        end

        # cpy a c
        # inc a
        # dec b
        # jnz b -2
        # cpy c b
        # dec d
        # jnz d -6
        a = fibonacci(d + 2)

        # cpy 16 c
        # cpy 17 d
        # inc a
        # dec d
        # jnz d -2
        # dec c
        # jnz c -5
        a + 17 * 16
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
        IO.inspect registers
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
        value = with {int, _} <- Integer.parse(x) do
            int
        else
            :error -> registers[x]
        end

        if value == 0 do
            {registers, index + 1}
        else
            {registers, index + String.to_integer(y)}
        end
    end
end
