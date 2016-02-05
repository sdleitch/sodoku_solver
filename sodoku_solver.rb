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
def find_used_cell_numbers(row, col)
  used_nums = []
  used_nums << find_row_numbers(row)
  used_nums << find_col_numbers(col)
  used_nums << find_box_numbers(row, col)
  used_nums.flatten!.uniq!

  return used_nums
end

# Returns possible answers in a row.
def find_row_numbers(row)
  used_nums = []
  SODOKU[row].each do |cell|
    cell != 0 ? used_nums << cell : nil
  end
  return used_nums
end

# Returns possible answers in a col.
def find_col_numbers(col)
  used_nums = []
  row = 0
  SODOKU.length.times do
    SODOKU[row][col] != 0 ? used_nums << SODOKU[row][col] : nil
    row += 1
  end
  return used_nums
end

# Return possible numbers from box
def find_box_numbers(row, col)
  used_nums = []

  row_box = (row / 3) * 3
  col_box = (col / 3) * 3

  (row_box..row_box + 2).each do |row|
    (col_box..col_box + 2).each do |col|
      SODOKU[row][col] != 0 ? used_nums << SODOKU[row][col] : nil
    end
  end
  return used_nums
end
