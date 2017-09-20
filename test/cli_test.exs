defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [ parse_args: 1,
                             sort_into_ascending_order: 1]
  import ExUnit.CaptureIO

  alias Issues.TableFormatter, as: TF

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["user", "project", "99"]) == { "user", "project", 99 }
  end

  test "count is defaulted if two values given" do
    assert parse_args(["user", "project"]) == { "user", "project", 4 }
  end

  test "sort ascending orders the correct way" do
    result = sort_into_ascending_order(fake_created_at_list(["c", "a", "b"]))
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues == ~w{a b c}
  end

  defp fake_created_at_list(values) do
    for value <- values,
    do: %{"created_at" => value, "other_data" => "xxx"}
  end

  def simple_test_data do
    [
      [ c1: "r1 c1", c2: "r1 c2", c3: "r1 c3", c4: "r1+++c4"],
      [ c1: "r2 c1", c2: "r2 c2", c3: "r2 c3", c4: "r2 c4"],
      [ c1: "r3 c1", c2: "r3 c2", c3: "r3 c3", c4: "r3 c4"],
      [ c1: "r4 c1", c2: "r4++c2", c3: "r4 c3", c4: "r4 c4"]
    ]
  end

  def headers, do: [:c1, :c2, :c4]

  def split_with_three_columns, do: TF.split_into_columns(simple_test_data(), headers())

  test "split_into_colums" do
    columns = split_with_three_columns()

    assert length(columns) == length(headers())
    assert List.first(columns) == ["r1 c1", "r2 c1", "r3 c1", "r4 c1"]
    assert List.last(columns) == ["r1+++c4", "r2 c4", "r3 c4", "r4 c4"]
  end

  test "column_widths" do
    widths = TF.widths_of(split_with_three_columns())
    assert widths == [ 5, 6, 7 ]
  end

  test "correct format string returned" do
    assert TF.format_for([9, 10, 11]) == "~-9s | ~-10s | ~-11s~n"
  end

  # test "Output is correct" do
  #   result = capture_io fn ->
  #     TF.print_table_for_columns(simple_test_data(), headers())
  #   end
  #
  #   assert result == """
  #   c1    | c2     | c4
  #   ------+--------+--------
  #   r1 c1 | r1 c2  | r1+++c4
  #   r2 c1 | r2 c2  | r2 c4
  #   r3 c1 | r3 c2  | r3 c4
  #   r4 c1 | r4++c2 | r4 c4
  #   """
  # end
end
