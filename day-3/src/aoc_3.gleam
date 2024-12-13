import gleam/io
import gleam/regexp.{Options, compile, scan}
import gleam/string
import simplifile

pub fn main() {
  let filepath = "./puzzle_input.txt"

  let contents = read_file(filepath)

  io.println("Hello from aoc_3!")
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

pub fn extract_muls(input: String) {
  let opts = Options(False, True)
  let assert Ok(re) = compile("mul\\(([0-9]{1,3}),([0-9]{1,3})\\)", opts)

  scan(re, input)
}
