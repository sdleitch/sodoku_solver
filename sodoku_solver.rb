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
  prev_length = nil
  sodoku_length = SODOKU.flatten.length

  until sodoku_length == prev_length
    prev_length = sodoku_length

    sodoku.each do |r|
      row = sodoku.index(r)
      r.each do |cell|
        col = sodoku[row].index(cell)
        if cell == 0
          possible_nums = find_possible_cell_numbers(row, col)
          sodoku[row][col] = possible_nums
        elsif cell.class == Array && cell.length > 1
          remove_identical_array_numbers(row, col)
          check_if_unique(row, col, cell)
        elsif cell.class == Array && cell.length == 1
          sodoku[row][col] = cell[0]
        end
      end
      # p r
    end
    sodoku_length = SODOKU.flatten.length
  end

  until sodoku_length == 81
    sodoku.each do |r|
      row = sodoku.index(r)
      r.each do |cell|
        col = sodoku[row].index(cell)

        if cell.class == Array && cell.length > 1
          possible_nums = find_possible_cell_numbers(row, col)
          sodoku[row][col] = possible_nums
        elsif cell.class == Array && cell.length == 1
          sodoku[row][col] = cell[0]
        end
      end
      # p r
    end
    sodoku_length = SODOKU.flatten.length
  end

  puts "Your sodouku result is: \n\n"

  sodoku.each do |row|
    row.flatten!
    p row
  end

end

# Find possible numbers for cell
def find_possible_cell_numbers(row, col)
  possible_nums = [1, 2, 3, 4, 5, 6, 7, 8, 9]

  used_nums = []
  used_nums << find_row_numbers(row)
  used_nums << find_col_numbers(col)
  used_nums << find_box_numbers(row, col)
  used_nums.flatten!.uniq!

  used_nums.each { |num| possible_nums.include?(num) ? possible_nums.delete(num) : nil }

  return possible_nums
end

# Returns possible answers in a row.
def find_row_numbers(row)
  used_nums = []
  SODOKU[row].each do |cell|
    if cell != 0 && cell.class == Fixnum
      used_nums << cell
    elsif cell.class == Array
      # p "PROC"
    end
  end
  return used_nums
end

# Returns possible answers in a col.
def find_col_numbers(col)
  used_nums = []
  row = 0
  SODOKU.length.times do
    cell = SODOKU[row][col]
    if cell != 0 && cell.class == Fixnum
      used_nums << cell
    end
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
      cell = SODOKU[row][col]
      if cell != 0 && cell.class == Fixnum
        used_nums << cell
      end
    end
  end
  return used_nums
end

# If there are identical arrays, remove their values from other arrays in row, col, box
def remove_identical_array_numbers(row, col)
  cell = SODOKU[row][col]
  compare_row_arrays(row, col, cell)
  compare_col_arrays(col, cell)
  compare_box_arrays(row, col, cell)
end

# Remove values from rows
def compare_row_arrays(row, col, cell)
  number_indentical_cells = 0
  SODOKU[row].each do |compare_cell|
    if compare_cell == cell
      number_indentical_cells += 1
    end
  end

  if cell.length == number_indentical_cells
    SODOKU[row].map! do |compare_cell|
      if compare_cell.class == Array && (cell & compare_cell).any? && compare_cell != cell
        compare_cell -= cell
      else
        compare_cell = compare_cell
      end
    end
  end

end

# Remove values from columns
def compare_col_arrays(col, cell)
  number_indentical_cells = 0
  SODOKU.each do
    row = 0
    compare_cell = SODOKU[row][col]
    if compare_cell == cell
      number_indentical_cells += 1
    end
    row += 1
  end

  if cell.length == number_indentical_cells
    SODOKU.map! do |row|
      compare_cell = SODOKU[row][col]
      if compare_cell.class == Array && (cell & compare_cell).any? && compare_cell != cell
        compare_cell -= cell
      else
        compare_cell = compare_cell
      end
    end
  end

end

# Remove values from boxes

def compare_box_arrays(row, col, cell)
  number_indentical_cells = 0

  row_box = (row / 3) * 3
  col_box = (col / 3) * 3

  (row_box..row_box + 2).each do |row|
    (col_box..col_box + 2).each do |col|
      compare_cell = SODOKU[row][col]
      if compare_cell == cell
        number_indentical_cells += 1
      end
    end
  end

  if cell.length == number_indentical_cells
    (row_box..row_box + 2).each do |row|
      (col_box..col_box + 2).each do |col|
        compare_cell = SODOKU[row][col]
        if compare_cell.class == Array && (cell & compare_cell).any? && compare_cell != cell
          SODOKU[row][col] -= cell
        else
          SODOKU[row][col] = compare_cell
        end
      end
    end
  end

end

def check_if_unique(row, col, cell)
  cell.each do |n|
    all_row_nums = SODOKU[row].flatten

    row_duplicates = all_row_nums.select { |element| all_row_nums.count(element) > 1 }
    if !row_duplicates.include?(n)
      SODOKU[row][col] = n
      break
    end

    all_col_nums = []
    SODOKU.each { |r| all_col_nums << r[col] }
    all_col_nums.flatten!

    col_duplicates = all_col_nums.select { |element| all_col_nums.count(element) > 1 }
    if !col_duplicates.include?(n)
      SODOKU[row][col] = n
      break
    end
  end
end
