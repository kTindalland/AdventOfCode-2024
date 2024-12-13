import aoc_3.{extract_muls}
import gleam/io.{debug}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
}

pub fn extract_muls_test() {
  let input =
    "mul(1,3)ghjkmulghjkmul(123,123)
    mul(2,2)"

  let result = extract_muls(input)

  debug(result)
}
