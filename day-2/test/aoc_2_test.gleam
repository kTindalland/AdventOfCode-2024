import gleeunit
import gleeunit/should
import aoc_2
import gleam/list
import gleam/int
import gleam/string
import gleam/result

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
}

pub fn check_ascending_test() {
  let lst = [1, 2, 3, 4, 5]

  let assert Ok(1) = aoc_2.check_ascending(0, lst, True)
}

pub fn check_ascending_fail_test() {
  let lst = [1, 0, 3, 4, 5]

  let assert Error(Nil) = aoc_2.check_ascending(0, lst, True)
}

pub fn check_descending_test() {
  let lst = [5, 4, 3, 2, 1]

  let assert Ok(1) = aoc_2.check_descending(6, lst, True)
}

pub fn convert_int_test() {
  let foo = "10 11 12"
  let result = aoc_2.convert_to_int_list(foo)

  should.equal(result, [10, 11, 12])
}

pub fn example_test() {
  let bar = [
    [7, 6, 4, 2, 1],
    [1, 2, 7, 8, 9],
    [9, 7, 6, 2, 1],
    [1, 3, 2, 4, 5],
    [8, 6, 4, 4, 1],
    [1, 3, 6, 7, 9]]

  let result = bar
    |> list.map(fn(line) { aoc_2.calculate_safe(line, False) })
    |> list.fold(0, int.add)

  should.equal(result, 2)
}

pub fn example_with_dampener_test() {
  let bar = [
    [7, 6, 4, 2, 1],
    [1, 2, 7, 8, 9],
    [9, 7, 6, 2, 1],
    [1, 3, 2, 4, 5],
    [8, 6, 4, 4, 1],
    [1, 3, 6, 7, 9],
    [20, 3, 6, 7, 9],
    [20, 6, 4, 2, 1],
    [7, 20, 4, 2, 1],
    [20, 20, 4, 2, 1],
    [1, 3, 6, 7, 20],
    [4, 2, 6, 7],
    [29, 28, 27, 25, 26, 25, 22, 20]]

  let result = bar
    |> list.map(fn(line) { aoc_2.calculate_safe(line, True) })
    |> list.fold(0, int.add)

  should.equal(result, 10)
}

pub fn example_string_test() {
  let foo = "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9"

  let result = foo
    |> string.split("\n")
    |> list.map(fn(line) { aoc_2.convert_to_int_list(line) })
    |> list.map(fn(line) { aoc_2.calculate_safe(line, False) })
    |> list.fold(0, int.add)

  should.equal(result, 2)
}

pub fn line_count_test() {
  let contents = "./puzzle_input.txt"
    |> aoc_2.read_file
    |> string.split("\n")
    |> list.map(fn(line) { aoc_2.convert_to_int_list(line) })
    |> list.filter(fn(line) { list.length(line) > 1 })

  let assert [66, 67, 68, 71, 72, 69] = contents
    |> list.first
    |> result.unwrap([])

  let assert [40, 42, 44, 46, 49, 51] = contents
    |> list.last
    |> result.unwrap([])

  should.equal(1000, list.length(contents))
}
