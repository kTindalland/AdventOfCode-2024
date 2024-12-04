import gleam/io
import gleam/int
import gleam/result
import gleam/string
import gleam/list
import simplifile

pub fn main() {
  let filepath = "./puzzle_input.txt"

  let contents = read_file(filepath)

  let contents_list = string.split(contents, "\n")

  let foo = contents_list
    |> list.map(fn(line) { convert_to_int_list(line) })
    |> list.filter(fn(line) { list.length(line) > 1 })
    |> list.map(fn(line) { calculate_safe(line) })
    |> list.fold(0, int.add)
    |> int.to_string

  io.println(foo)

}

pub fn read_file(filename: String) -> String {
  case simplifile.read(filename) {
    Ok(contents) -> contents
    Error(error) -> panic as string.append("Failed to read the puzzle input! ", simplifile.describe_error(error))
  }
}

pub fn convert_to_int_list(line: String) {
  line
    |> string.split(" ")
    |> list.map(fn(item) { item |> int.parse |> result.unwrap(0) })
}

pub fn calculate_safe(line: List(Int)) {
  let asc = calculate_safe_asc(line)
  let desc = calculate_safe_desc(line)

  let or_result = result.or(asc, desc)
  result.unwrap(or_result, 0)
}

pub fn calculate_safe_asc(line: List(Int)) {
  case line {
    [first, ..rest] -> check_ascending(first, rest)
    _ -> Error(Nil)
  }
}

pub fn calculate_safe_desc(line: List(Int)) {
  case line {
    [first, ..rest] -> check_descending(first, rest)
    _ -> Error(Nil)
  }
}

pub fn check_ascending(prev: Int, line: List(Int)) {
  case line {
    [first, ..rest] -> case prev < first && first - prev < 4 {
      True -> check_ascending(first, rest)
      _ -> Error(Nil)
    }
    _ -> Ok(1)
  }
}

pub fn check_descending(prev: Int, line: List(Int)) {
  case line {
    [first, ..rest] -> case prev > first && prev - first < 4 {
      True -> check_descending(first, rest)
      _ -> Error(Nil)
    }
    _ -> Ok(1)
  }
}

