require_relative 'collection'

module Sudoku
  class Board < Collection
  # Board represents 81 cells in a 9X9 square
  # Each board contains 9 rows, columns and blocks
  # Board can be represented by a two-dimensional hash of cells

    attr_accessor :cells, :solutions, :unsolved_cell_ids

    def initialize
    # Creates blank board. No cell contains a solution or any eliminated
    # possible solutions.
      @cells = []
      @solutions = []

      id = 1; while id <= 81 
        @cells << (Cell.new(id))
        id += 1
      end
    end 

    def populate_board rows={} 
    # Populates board with pre-populated two-dimensional hash
    # Blank cells are represented by 0's in the hash.
      r = 1; id = 1
      until r == 10
        c = 0
        until c == 9
          self.cell(id).set_solution(rows[r][c]) unless
            rows[r][c] == 0
          c += 1; id += 1
        end
        r += 1
      end
    end

    def add_board_row row=[], row_id
      i = 0; id = (row_id * 9) - 8
      9.times do
        self.cell(id).set_solution(row[i]) unless row[i] == 0
        i += 1; id += 1
      end
    end

  ###################################################################
  ###### METHODS TO RETRIEVE SPECIFIC COLLECTIONS ON THE BOARD ######
  ###################################################################

  # row, col and block methods need to be modified so a new Collection 
  # is not created each time a row, column or block is modified.
  # Potential solution would be to have an instance variable for each 
  # unique row, column and block. These methods would then just return 
  # the correct collection.
                
    def row id 
    # Single cell ID as an arg and returns entire row the cell is part of.
      row = Collection.new
      cur_cell = self.cell(id)
      row_head_id = cur_cell.row_head_id
    
      9.times do
        cell = self.cell(row_head_id)
        row.add_cell(cell)
        row_head_id += 1
      end
      row
    end

    def col id 
    # Single cell ID as an arg and returns entire column the cell is part of.
      col = Collection.new
      cur_cell = self.cell(id)
      col_head_id = cur_cell.col_head_id
    
      9.times do
        cell = self.cell(col_head_id)
        col.add_cell(cell)
        col_head_id += 9
      end
      col
    end

    def block id 
    # Single cell ID as an arg and returns entire block the cell is part of.
      block = Collection.new
      cur_cell = self.cell(id)
      block_ids = cur_cell.block
      block_ids.each do |block_id|
        cell = self.cell(block_id)
        block.add_cell(cell)
      end
      block
    end

    def row_by_row_id id
    # Row ID as an arg and returns entire row.
    # i.e. Row ID 1 includes cells with IDs 1..9
    # i.e. Row ID 3 includes cells with IDs 19..27 
      cell_id = id * 9 - 8
      self.row(cell_id)
    end

    def col_by_col_id id 
    # Column ID as an arg and returns entire row.
    # i.e. Column ID 1 includes cells [1,10,19,28,36,45,54,63,72]
      if id % 9 == 0
        cell_id = 9
      else
        cell_id = id % 9
      end
      self.col(cell_id)
    end

    def block_by_block_id id
    # Block ID as an arg and returns entire row.
    # i.e. Block ID 1 includes cells [1,2,3,10,11,12,19,20,21]
      cell = Cell.new(1)
      blocks = cell.populate_blocks
      self.block(blocks[id][1])
    end

    def board_errors?
    # Checks all rows, columns and blocks for duplicate solutions in 
    # any one collection.
      id = 1
      9.times do
        return true if self.row_by_row_id(id).errors? || self.col_by_col_id(id).errors? || self.block_by_block_id(id).errors?
        id += 1
      end
      false
    end

    def blank_cells?
    # Returns if there are any cells yet to be populated with a solution.
      i = 1; until i == 10
        row = self.row_by_row_id(i)
        break if row.solutions.length < 9
        i += 1
      end
      return false if i == 10
        return true
    end

    def solved?
    # Checks whether puzzle has been solved.  Only checks for the solution
    # once all cells have been populated.
      if self.blank_cells?
        puts "There are still blank cells on the board."
        return false
      elseif self.board_errors?
        puts "Sorry.  There are some errors on the board."
      else
        i = 1; until i == 9
          break unless self.row_by_row_id(i).check_solutions || self.col_by_col_id(i).check_solutions || self.block_by_block_id(i).check_solutions
          i += 1
        end
        self.print_board
        return true unless i != 9
      end
    end

    def print_board
      print " ___" * 9 << "\n"
      id = 1
      self.cells.each do |cell|
        print "|" if (id-1) % 9 == 0
        cell.print_cell
        print "\n" if id % 9 == 0
        id += 1
      end
    end

  ###################################################################
  ###################### THE SOLVING ALGORITHM ######################
  ###################################################################

    def solve itr=1 
    # Iterates through array of unsolved cells until solved or through 10 iterations.
    # Calls solver methods for each collection each unsolved cell is a part of.
    # Tests for a correct solution once all cells are populated.
      if itr == 11
        puts "I couldn't solve it.  This must be a tough one."
      else
        self.unsolved_ids.each do |cell_id|
          self.solve_row(cell_id)   
          self.solve_block(cell_id)
          self.solve_col(cell_id)
        end
          if self.blank_cells?
            itr += 1
            self.solve(itr)
          else
            self.solved?
          end
      end
    end

    def unsolved_ids
    # Helper method for solve
    # Returns array of cell ids of cells that have yet to be solved.
    # Enables solver to iterate over only unsolved cells.
      unsolved_cell_ids = []
      @cells.each do |cell|
        unsolved_cell_ids.push(cell.id) if cell.solution.nil?
      end
      unsolved_cell_ids
    end

    def solve_row id 
      row = self.row(id)
      row.solve_by_values(row.solutions)
      row.solve_by_solutions
      row.solve_by_doubles
      row.solve_by_triples
    end

    def solve_col id 
      col = self.col(id)
      col.solve_by_values(col.solutions)
      col.solve_by_solutions
      col.solve_by_doubles
      col.solve_by_triples
    end

    def solve_block id 
      block = self.block(id)
      block.solve_by_values(block.solutions)
      block.solve_by_solutions
      block.solve_by_doubles
      block.solve_by_triples
    end
  end
end