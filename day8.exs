defmodule LittleScreen do
    def blank(rows \\ 6, columns \\ 50) do
        List.duplicate(false, columns)
        |> List.duplicate(rows)
    end

    def rect screen, columns, rows do
        rect screen, columns, rows, []
    end

    defp rect [], _, _, new_screen do
        Enum.reverse new_screen
    end

    defp rect [row | old_screen], columns, 0, new_screen do
        rect old_screen, columns, 0, [row | new_screen]
    end

    defp rect [row | old_screen], columns, rows, new_screen do
        new_row = rect_row row, columns
        rect old_screen, columns, rows-1, [new_row | new_screen]
    end

    def rect_row row, columns do
        rect_row row, columns, []
    end

    defp rect_row [], _, new_row do
        Enum.reverse new_row
    end

    defp rect_row [ col | old_row], 0, new_row do
        rect_row old_row, 0, [col | new_row]
    end

    defp rect_row [ _ | old_row], columns, new_row do
        IO.puts columns
        rect_row old_row, columns - 1, [true | new_row]
    end

    def rotate_row screen, row, shift do
        new_row = Enum.at(screen, row)
                  |> Enum.split(-shift)
                  |> swap

        List.replace_at screen, row, new_row
    end

    def swap {front, back} do
        back ++ front
    end

    def rotate_column screen, column, shift do
        col_list = Enum.map(screen, &(Enum.at &1, column))
                   |> Enum.split(-shift)
                   |> swap

        Enum.zip(screen, col_list)
        |> Enum.map(fn {row, val} -> List.replace_at row, column, val end)
    end

    def voltage screen do
        Enum.reduce screen, 0, &(row_voltage(&1) + &2)
    end

    defp row_voltage row do
        Enum.count row, &(&1)
    end

    def to_display screen do
        Enum.map screen, &row_to_string/1
    end

    defp row_to_string row do
        row
        |> Enum.map(&led/1)
        |> Enum.join
    end

    defp led(bool) when bool do
        "*"
    end

    defp led(bool) when not bool do
        " "
    end
end


defmodule Day8 do
    @rx ~r/^(?<command>rect|rotate row|rotate column) (?:[xy]=(?<loc>\d*) by (?<shift>\d*)|(?<x>\d*)x(?<y>\d*))/

    def get_input do
        File.read!('day8.txt')
        |> String.split("\n")
        |> Enum.map(&(Regex.named_captures @rx, &1))
    end

    def run do
        get_input
        |> Enum.reduce(LittleScreen.blank, &run_command/2)
        |> LittleScreen.voltage
    end

    def run_2 do
        get_input
        |> Enum.reduce(LittleScreen.blank, &run_command/2)
        |> LittleScreen.to_display
        |> Enum.each(&IO.puts/1)
    end

    def run_command %{"command" => "rect", "x" => columns, "y" => rows}, screen do

        LittleScreen.rect screen, String.to_integer(columns), String.to_integer(rows)
    end

    def run_command %{"command" => "rotate row", "loc" => row, "shift" => shift}, screen do

        LittleScreen.rotate_row screen, String.to_integer(row), String.to_integer(shift)
    end

    def run_command %{"command" => "rotate column", "loc" => column, "shift" => shift}, screen do

        LittleScreen.rotate_column screen, String.to_integer(column), String.to_integer(shift)
    end
end