SODOKU =
  [
    [0, 6, 0, 1, 0, 4, 0, 5, 0],
    [0, 0, 8, 3, 0, 5, 6, 0, 0],
    [2, 0, 0, 0, 0, 0, 0, 0, 1],
    [8, 0, 0, 4, 0, 7, 0, 0, 6],
    [0, 0, 6, 0, 0, 0, 3, 0, 0],
    [7, 0, 0, 9, 0, 1, 0, 0, 4],
    [5, 0, 0, 0, 0, 0, 0, 0, 2],
    [0, 0, 7, 2, 0, 6, 9, 0, 0],
    [0, 4, 0, 5, 0, 8, 0, 7, 0],
  ]

# def solve_sodoku(sodoku)
  # Methods will go here
# end

# Find possible numbers for cell
def find_possible_cell_numbers(row, col)
  possible_nums = []
end

# Returns possible answers in a row.
def find_possible_row_numbers(row)
  possible_nums = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  row.each do |cell|
    possible_nums.include?(cell) ? possible_nums.delete(cell) : nil
  end
  return possible_nums
end

# Returns possible answers in a col.
def find_possible_col_numbers(col)
  possible_nums = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  i = 0
  SODOKU.length.times do
    possible_nums.include?(SODOKU[i][col]) ? possible_nums.delete(SODOKU[i][col]) : nil
    i += 1
  end
  return possible_nums
end

# Return possible numbers from box
def find_possible_box_numbers(row, col)
  possible_nums = [1, 2, 3, 4, 5, 6, 7, 8, 9]

  row_box = (row / 3) * 3
  col_box = (col / 3) * 3

  (row_box..row_box + 2).each do |row|
    (col_box..col_box + 2).each do |col|
      possible_nums.include?(SODOKU[row][col]) ? possible_nums.delete(SODOKU[row][col]) : nil
    end
  end
  return possible_nums
end
