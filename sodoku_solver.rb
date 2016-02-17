require_relative 'input.rb'

def solve_sodoku(sodoku)
  prev_length = nil

  until sodoku.flatten.length == prev_length
    prev_length = sodoku.flatten.length
    sodoku = solve_cells(sodoku)
  end


  if sodoku.flatten.length > 81
    sodoku.each do |row|
      (0..8).each do |col|
        row[col] = 0 if row[col].class == Array
      end
    end
    recursive_solve(sodoku, 0, 0)
  end

  puts "Your sodoku result is: \n\n"

  SODOKU.each do |row|
    p row
  end

end

def solve_cells(sodoku)
  remove_identicals_from_sodoku(sodoku)
  remove_impossible_numbers(sodoku)
  return sodoku
end

def remove_impossible_numbers(sodoku)
  prev_length = nil
  sodoku_length = sodoku.flatten.length

  until sodoku_length == 81 || sodoku_length == prev_length
    prev_length = sodoku_length
    sodoku.each do |r|
      row = sodoku.index(r)
      r.each do |cell|
        col = sodoku[row].index(cell)
        if cell.class == Array && cell.length > 1
          possible_nums = find_possible_cell_numbers(row, col, sodoku)
          possible_nums.length > 0 ? sodoku[row][col] = possible_nums : nil
        elsif cell.class == Array && cell.length == 1
          sodoku[row][col] = cell[0]
        end
      end
    end
    sodoku_length = sodoku.flatten.length
    sodoku_length < 81 ? break : nil
  end
end

def remove_identicals_from_sodoku(sodoku)
  prev_length = nil
  sodoku_length = sodoku.flatten.length

  until sodoku_length == prev_length
    prev_length = sodoku_length

    sodoku.each do |r|
      row = sodoku.index(r)
      r.each do |cell|
        col = sodoku[row].index(cell)
        if cell == 0
          possible_nums = find_possible_cell_numbers(row, col, sodoku)
          sodoku[row][col] = possible_nums
        elsif cell.class == Array && cell.length > 1
          remove_identical_array_numbers(row, col, sodoku)
          check_if_unique(row, col, cell, sodoku)
        elsif cell.class == Array && cell.length == 1
          sodoku[row][col] = cell[0]
        end
      end
    end
    # puts sodoku_length
    sodoku_length = sodoku.flatten.length
  end
end

# Find possible numbers for cell
def find_possible_cell_numbers(row, col, sodoku)
  possible_nums = [1, 2, 3, 4, 5, 6, 7, 8, 9]

  used_nums = []
  used_nums << find_row_numbers(row, sodoku)
  used_nums << find_col_numbers(col, sodoku)
  used_nums << find_box_numbers(row, col, sodoku)
  used_nums.flatten!.uniq!

  used_nums.each { |num| possible_nums.include?(num) ? possible_nums.delete(num) : nil }

  return possible_nums
end

# Returns possible answers in a row.
def find_row_numbers(row, sodoku)
  used_nums = []
  sodoku[row].each do |cell|
    if cell != 0 && cell.class == Fixnum
      used_nums << cell
    elsif cell.class == Array
      # p "PROC"
    end
  end
  return used_nums
end

# Returns possible answers in a col.
def find_col_numbers(col, sodoku)
  used_nums = []
  row = 0
  sodoku.length.times do
    cell = sodoku[row][col]
    if cell != 0 && cell.class == Fixnum
      used_nums << cell
    end
    row += 1
  end
  return used_nums
end

# Return possible numbers from box
def find_box_numbers(row, col, sodoku)
  used_nums = []

  row_box = (row / 3) * 3
  col_box = (col / 3) * 3

  (row_box..row_box + 2).each do |row|
    (col_box..col_box + 2).each do |col|
      cell = sodoku[row][col]
      if cell != 0 && cell.class == Fixnum
        used_nums << cell
      end
    end
  end
  return used_nums
end

# If there are identical arrays, remove their values from other arrays in row, col, box
def remove_identical_array_numbers(row, col, sodoku)
  cell = sodoku[row][col]
  compare_row_arrays(row, col, cell, sodoku)
  compare_col_arrays(col, cell, sodoku)
  compare_box_arrays(row, col, cell, sodoku)
end

# Remove values from rows
def compare_row_arrays(row, col, cell, sodoku)
  number_indentical_cells = 0
  sodoku[row].each do |compare_cell|
    if compare_cell == cell
      number_indentical_cells += 1
    end
  end

  if cell.length == number_indentical_cells
    sodoku[row].map! do |compare_cell|
      if compare_cell.class == Array && (cell & compare_cell).any? && compare_cell != cell && compare_cell.length > cell.length
        compare_cell -= cell
      else
        compare_cell = compare_cell
      end
    end
  end

end

# Remove values from columns
def compare_col_arrays(col, cell, sodoku)
  number_indentical_cells = 0
  sodoku.each do
    row = 0
    compare_cell = sodoku[row][col]
    if compare_cell == cell
      number_indentical_cells += 1
    end
    row += 1
  end

  if cell.length == number_indentical_cells
    sodoku.map! do |row|
      compare_cell = sodoku[row][col]
      if compare_cell.class == Array && (cell & compare_cell).any? && compare_cell != cell && compare_cell.length > cell.length
        compare_cell -= cell
      else
        compare_cell = compare_cell
      end
    end
  end

end

# Remove values from boxes
def compare_box_arrays(row, col, cell, sodoku)
  number_indentical_cells = 0

  row_box = (row / 3) * 3
  col_box = (col / 3) * 3

  (row_box..row_box + 2).each do |row|
    (col_box..col_box + 2).each do |col|
      compare_cell = sodoku[row][col]
      if compare_cell == cell
        number_indentical_cells += 1
      end
    end
  end

  if cell.length == number_indentical_cells
    (row_box..row_box + 2).each do |row|
      (col_box..col_box + 2).each do |col|
        compare_cell = sodoku[row][col]
        if compare_cell.class == Array && (cell & compare_cell).any? && compare_cell != cell && compare_cell.length > cell.length
          sodoku[row][col] -= cell
        else
          sodoku[row][col] = compare_cell
        end
      end
    end
  end

end

def check_if_unique(row, col, cell, sodoku)
  cell.each do |n|
    all_row_nums = sodoku[row].flatten

    row_duplicates = all_row_nums.select { |element| all_row_nums.count(element) > 1 }
    if !row_duplicates.include?(n)
      sodoku[row][col] = n
      break
    end

    all_col_nums = []
    sodoku.each { |r| all_col_nums << r[col] }
    all_col_nums.flatten!

    col_duplicates = all_col_nums.select { |element| all_col_nums.count(element) > 1 }
    if !col_duplicates.include?(n)
      sodoku[row][col] = n
      break
    end
  end
end

def recursive_solve(sodoku, row, col)

  if row == 9
    return true
  end

  nums = sodoku[row][col]

  if nums != 0 #.class != Array
    puts "SOLVED: #{nums}"
    if col == 8
      return true if recursive_solve(sodoku, row + 1, 0)
    else
      return true if recursive_solve(sodoku, row, col + 1)
    end

    return false
  end

  for num in (1..9)
    # puts "NEXT NUM: " + num.to_s
    if find_possible_cell_numbers(row, col, sodoku).include?(num)
      sodoku[row][col] = num

      if col == 8
        return true if recursive_solve(sodoku, row + 1, 0)
      else
        return true if recursive_solve(sodoku, row, col + 1)
        end
    end
    sodoku[row][col] = nums
    puts "row: #{row}, col #{col}, num: #{num}"
  end

  return false
end

solve_sodoku(SODOKU)
