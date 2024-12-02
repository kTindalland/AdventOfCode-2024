import gleam/io
import gleam/result
import gleam/int
import gleam/dict.{type Dict}
import gleam/list
import gleam/string
import simplifile

pub fn main() {
  let filepath = "./puzzle_input.txt"

  let contents = read_file(filepath)

  let contents_list = string.split(contents, "\n")

  let initial_dict = dict.new() |> dict.insert("left", []) |> dict.insert("right", [])

  let result = initial_dict
    |> add_all_elements(contents_list)
    |> sort_lists
    |> calc_differences
    |> dict.get("diff")
    |> result.unwrap([])
    |> list.fold(0, int.add)
    |> int.to_string

  io.println(result)

  let result_2 = initial_dict
    |> add_all_elements(contents_list)
    |> calc_sim_from_dict
    |> list.fold(0, int.add)
    |> int.to_string

  io.println("Sim score result: " <> result_2)
}

pub fn read_file(filename: String) -> String {
  case simplifile.read(filename) {
    Ok(contents) -> contents
    Error(error) -> panic as string.append("Failed to read the puzzle input! ", simplifile.describe_error(error))
  }
}

pub fn add_element(current_lists: Dict(String, List(Int)), line: String) {
  let left = line
    |> string.slice(0, 5)
    |> int.parse
    |> result.unwrap(0)

  let right = line
    |> string.slice(8, 5)
    |> int.parse
    |> result.unwrap(0)

  let assert Ok(left_list) = dict.get(current_lists, "left")
  let assert Ok(right_list) = dict.get(current_lists, "right")

  current_lists
  |> dict.insert("left", list.append(left_list, [left]))
  |> dict.insert("right", list.append(right_list, [right]))
}

pub fn add_all_elements(current_dict: Dict(String, List(Int)), contents_list: List(String)){
  case contents_list {
    [first, ..rest] -> add_all_elements(add_element(current_dict, first), rest)
    [] -> current_dict
  }
}

pub fn sort_lists(current_dict: Dict(String, List(Int))) {
  current_dict
    |> sort_list("left")
    |> sort_list("right")
}

pub fn sort_list(current_dict: Dict(String, List(Int)), key: String) {
  let assert Ok(current_list) = dict.get(current_dict, key)
  let sorted_list = list.sort(current_list, int.compare)

  current_dict
    |> dict.insert(key, sorted_list)
}

pub fn calc_difference(current_dict: Dict(String, List(Int))) {
  let assert Ok(left_list) = dict.get(current_dict, "left")
  let assert Ok(right_list) = dict.get(current_dict, "right")

  let assert Ok(popped_left) = list.pop(left_list, fn(_) { True })
  let assert Ok(popped_right) = list.pop(right_list, fn(_) { True })

  let difference = int.absolute_value(popped_left.0 - popped_right.0)
  let diff_list = current_dict
    |> dict.get("diff")
    |> result.unwrap([])
    |> list.append([difference])

  current_dict
    |> dict.insert("left", popped_left.1)
    |> dict.insert("right", popped_right.1)
    |> dict.insert("diff", diff_list)
}

pub fn calc_differences(current_dict: Dict(String, List(Int))) {
  let is_done = current_dict
    |> dict.get("left")
    |> result.unwrap([])
    |> list.is_empty

  case is_done {
    False -> calc_differences(calc_difference(current_dict))
    _ -> current_dict
  }
}

pub fn calc_sim_from_dict(current_dict: Dict(String, List(Int))) {
  let assert Ok(left_list) = dict.get(current_dict, "left")
  let assert Ok(right_list) = dict.get(current_dict, "right")

  calc_sim_scores([], left_list, right_list)
}

pub fn calc_sim_scores(sim_scores: List(Int), left_list: List(Int), right_list: List(Int)) {
  case left_list {
    [first, ..rest] -> calc_sim_scores(find_similarity_score(sim_scores, first, right_list), rest, right_list)
    _ -> sim_scores
  }
}

pub fn find_similarity_score(current_scores: List(Int), current_num: Int, right_list: List(Int)) {
  let compare_func = fn(total, next_val) {compare_num(current_num, total, next_val)}
  let result = current_num * list.fold(right_list, 0, compare_func)

  list.append(current_scores, [result])
}

pub fn compare_num(comparitor: Int, total: Int, next_val: Int) {
  case comparitor == next_val {
    True -> int.add(total, 1)
    _ -> total
  }
}
