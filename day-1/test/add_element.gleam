import gleeunit
import gleeunit/should
import gleam/list
import aoc_1
import gleam/dict
import gleam/int
import gleam/io

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn add_element_test() {
  // Arrange
  let dictionary = dict.new() |> dict.insert("left", []) |> dict.insert("right", [])
  let line = "12345   67890"

  // Act
  let result = aoc_1.add_element(dictionary, line)

  // Assert
  let assert Ok(left_list) = dict.get(result, "left")
  let assert Ok(right_list) = dict.get(result, "right")
  
  let assert Ok(12345) = list.first(left_list)
  let assert Ok(67890) = list.first(right_list)
}

pub fn add_element_multi_line_test() {
  // Arrange
  let dictionary = dict.new() |> dict.insert("left", []) |> dict.insert("right", [])
  let line = "12345   67890"
  let line2 = "12346   67891"

  // Act
  let result = dictionary
   |> aoc_1.add_element(line)
   |> aoc_1.add_element(line2)

  // Assert
  let assert Ok([12345, 12346]) = dict.get(result, "left")
  let assert Ok([67890, 67891]) = dict.get(result, "right")
}

pub fn add_all_elements_test() {
  // Arrange 
  let dictionary = dict.new() |> dict.insert("left", []) |> dict.insert("right", [])
  let line_list = [ "12345   67890", "12346   67891"]

  // Act
  let result = aoc_1.add_all_elements(dictionary, line_list)

  // Assert
  let assert Ok([12345, 12346]) = dict.get(result, "left")
  let assert Ok([67890, 67891]) = dict.get(result, "right")
}

pub fn sort_lists_test() {
  // Arrange
  let dictionary = dict.new() 
    |> dict.insert("left", [4, 3, 7, 5]) 
    |> dict.insert("right", [9, 5, 3, 2])

  // Act
  let result = aoc_1.sort_lists(dictionary)

  // Assert
  let assert Ok([3, 4, 5, 7]) = dict.get(result, "left")
  let assert Ok([2, 3, 5, 9]) = dict.get(result, "right")
}

pub fn calc_differences_test() {
  // Arrange
  let dictionary = dict.new() 
    |> dict.insert("left", [4, 3, 7, 5]) 
    |> dict.insert("right", [9, 5, 3, 2])

  // Act
  let result = aoc_1.calc_differences(dictionary)

  // Assert
  let assert Ok([5, 2, 4, 3]) = dict.get(result, "diff")
}

pub fn find_similarity_score_test() {
  // Arrange
  let lst = [1, 2, 2, 4, 5, 2]

  // Act
  let result = aoc_1.find_similarity_score([], 2, lst)
  
  // Assert
  should.equal(result, [6])
}

pub fn calc_sim_scores_test() {
  // Arrange
  let right_list = [1, 2, 2, 4, 5, 2]
  let left_list = [1, 2, 3]
  
  // Act
  let result = aoc_1.calc_sim_scores([], left_list, right_list)

  // Assert
  should.equal(result, [1, 6, 0])
}

pub fn calc_sim_from_dict_test() {
  // Arrange
  let dictionary = dict.new() 
    |> dict.insert("left", [3, 4, 2, 1, 3, 3]) 
    |> dict.insert("right", [4, 3, 5, 3, 9, 3])

  // Act
  let result = dictionary
    |> aoc_1.calc_sim_from_dict
    |> io.debug
    |> list.fold(0, int.add)

  // Assert
  should.equal(result, 31)
}
