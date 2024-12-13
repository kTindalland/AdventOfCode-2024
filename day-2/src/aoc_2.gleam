import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let filepath = "./puzzle_input.txt"

  let contents = read_file(filepath)

  let contents_list = string.split(contents, "\n")

  let foo =
    contents_list
    |> list.map(fn(line) { convert_to_int_list(line) })
    |> list.filter(fn(line) { list.length(line) > 1 })
    |> list.map(fn(line) { calculate_safe(line, False) })
    |> list.fold(0, int.add)
    |> int.to_string

  io.println(foo)

  let bar =
    contents_list
    |> list.map(fn(line) { convert_to_int_list(line) })
    |> list.filter(fn(line) { list.length(line) > 1 })
    |> list.map(fn(line) { calculate_safe_with_dampener(line) })
    |> list.fold(0, int.add)
    |> int.to_string
  io.println(bar)
}

pub fn read_file(filename: String) -> String {
  case simplifile.read(filename) {
    Ok(contents) -> contents
    Error(error) ->
      panic as string.append(
        "Failed to read the puzzle input! ",
        simplifile.describe_error(error),
      )
  }
}

pub fn convert_to_int_list(line: String) {
  line
  |> string.split(" ")
  |> list.map(fn(item) { item |> int.parse |> result.unwrap(0) })
}

pub fn calculate_safe(line: List(Int), dampener: Bool) {
  let asc = calculate_safe_asc(line, dampener)
  let desc = calculate_safe_desc(line, dampener)

  let or_result = result.or(asc, desc)
  result.unwrap(or_result, 0)
}

pub fn calculate_safe_with_dampener(line: List(Int)) {
  let initial_result = calculate_safe(line, False)

  case initial_result {
    0 ->
      line
      |> calc_split(0, list.length(line))
      |> result.unwrap(0)
    _ -> initial_result
  }
}

pub fn calc_split(line: List(Int), current_index: Int, length: Int) {
  use _ <- result.try(check_length(current_index, length))

  let left = list.take(line, current_index)
  let right = list.drop(line, current_index + 1)

  let combined = list.append(left, right)

  let calc_result = calculate_safe(combined, False)

  case calc_result {
    1 -> Ok(1)
    _ -> calc_split(line, current_index + 1, length)
  }
}

pub fn check_length(current_index: Int, length: Int) {
  case current_index >= length {
    True -> Error(Nil)
    _ -> Ok(0)
  }
}

pub fn calculate_safe_asc(line: List(Int), dampener: Bool) {
  case line {
    [first, ..rest] -> {
      let foo = check_ascending(first, rest, bool.negate(dampener))
      case dampener {
        True ->
          result.try_recover(foo, fn(_) { calculate_safe_asc(rest, False) })
        _ -> foo
      }
    }
    _ -> Error(Nil)
  }
}

pub fn calculate_safe_desc(line: List(Int), dampener: Bool) {
  case line {
    [first, ..rest] -> {
      let foo = check_descending(first, rest, bool.negate(dampener))
      case dampener {
        True ->
          result.try_recover(foo, fn(_) { calculate_safe_desc(rest, False) })
        _ -> foo
      }
    }
    _ -> Error(Nil)
  }
}

pub fn check_ascending(prev: Int, line: List(Int), already_dampened: Bool) {
  case line {
    [first, ..rest] ->
      case prev < first && first - prev < 4 {
        True -> check_ascending(first, rest, already_dampened)
        _ ->
          case already_dampened {
            False -> check_ascending(prev, rest, True)
            _ -> Error(Nil)
          }
      }
    _ -> Ok(1)
  }
}

pub fn check_descending(prev: Int, line: List(Int), already_dampened: Bool) {
  case line {
    [first, ..rest] ->
      case prev > first && prev - first < 4 {
        True -> check_descending(first, rest, already_dampened)
        _ ->
          case already_dampened {
            False -> check_descending(prev, rest, True)
            _ -> Error(Nil)
          }
      }
    _ -> Ok(1)
  }
}
