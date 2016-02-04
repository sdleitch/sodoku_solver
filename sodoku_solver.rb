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

def solve_sodoku(sodoku)
  # Methods will go here
end

def find_possible_rows(row)
  possible_nums = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  row.each do |cell|
    possible_nums.include?(cell) ? possible_nums.delete(cell) : nil
  end
  # row.each do |cell|
  #   if cell == 0
  #
  #   end
  # end
end
