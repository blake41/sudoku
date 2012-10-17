require_relative 'cell'

module Sudoku
  class Collection
  # Collection represents any grouping of cells on a Sudoku board
  # This includes a row, column, block (1 of the nine 3X3 groupings of cells) or the board itself
  # Each collection is represented by an array of cells

    attr_accessor :cells, :solutions

    def initialize cells=[]
      @cells = cells
      @solutions = []
    end

    def add_cell cell
      @cells << cell  
    end

    def cell id 
      @cells.each do |cell|
        return cell if cell.id == id
      end  
    end

    def values
    # Returns an array of arrays of the remaining possible values for each cell in self
      values = []
      @cells.each do |cell|
        values.push(cell.values)
      end
      values
    end

    def solutions
    # Updates and returns the @solutions array
    # It must be updated prior to being returned to capture
    # any cells that have been solved since the last update
      @cells.each do |cell|
        @solutions << cell.solution unless 
          cell.solution.nil? || @solutions.include?(cell.solution)
      end
      @solutions
    end

    def check_solutions
      self.solutions.sort == [1,2,3,4,5,6,7,8,9]
    end

    def errors?
    # Determines if there are any duplicate solutions in a collection,
    # which would represent an error in the puzzle.
      sols = []
      @cells.each {|c| sols << c.solution unless c.solution.nil? }
      sols.uniq != sols
    end

  ####################################################################
  ############ FLEET OF SOLVER METHODS AND HELPER METHODS ############
  ####################################################################

  def solve_by_values val=[]
    # Solves by removing possible solutions from a collection of cells.
    # Cells within the collection will be solved when only one possible solution reaains.
      @cells.each do |cell|
          cell.update_cell_val( val )
      end
    end

    def solve_by_solutions
    # Solves by finding possible solutions that exist only once within a particular collection.
    # The cell where that unique possible solution exists is set to such unique solution.
      values = self.values
      uniqs = self.uniq_values
      @cells.each do |cell|
        if cell.solution.nil?
          uniqs.each do |u| 
            if cell.values.include?(u)
              cell.set_solution(u)
              uniqs.delete(u)
            end
          end
        end
      end
    end

    def uniq_values
    # Helper method for solve_by_solutions
    # Finds and returns any remaining possible values in the collection that are only present in one cell.
    # Finding a unique value indicates such value should be the solution of 
    # cell in which it is found.
      count_hash = {}
      values = self.values.flatten.sort.each do |value| 
        if count_hash[value].nil?
          count_hash[value] = 1
        else
          count_hash[value] = count_hash[value] + 1
        end
      end
      count_hash.delete_if {|key, value| value > 1}
      count_hash.keys
    end

    def solve_by_doubles
      unless self.doubles.nil?
        @cells.each do |cell|
          cell.update_cell_val(self.doubles)
        end
      end
    end

    def doubles
    # Helper method for solve_by_doubles
    # Finds and returns any Doubles. Returned as hash with cell ID as key and possible values as hash values.
    # Doubles represent a situation in which two cells in a row, column or block
    # have the same two values as possible solutions.  This indicates that no other
    # cell in the collection could be either of those two values.
      doubles = {}
      @cells.each do |cell|
        doubles[cell.id] = cell.values if cell.values.length == 2
      end
      doubles_array = nil
      if doubles.length >= 2
        doubles.each do |k, v|
          copy = doubles.dup
          copy.delete(k)
          doubles_array = v if copy.has_value?(v)
        end
        doubles_array
      end
    end

    def solve_by_triples
      @cells.each do |cell|
        cell.update_cell_triples(self.triples) unless self.triples.nil?
      end
    end

    def triples
    # Helper method for solve_by_triples
    # Finds and returns Triples. Returned as array of 3 possible values in Triple. 
    # Triples represent 3 cells in one collection that do not contain 
    # any other numbers other than the three possible values of those three cells
    # This indicates that no other cell in the collection could be any of those three values.
      t_hash = {}
      self.triples_cells.each do |cell|
        matches = 0
        copy = self.triples_cells.dup
        copy.delete(cell)
        copy.each do |c_cell|
          matches += 1 if self.triples_match(c_cell.values, cell.values)
          t_hash[cell.id] = cell.values if matches == 2
        end
      end
      return t_hash.values.flatten.uniq if t_hash.length == 3
    end

    def triples_cells
    # Helper method for solve_by_triples
    # Finds any cells that could potentially be part of a triple.
    # Triples must have 2 or 3 possible solutions remaining.
      t_cells = @cells.dup
      t_cells.keep_if{|c| c.values.length == 2 || c.values.length == 3}
      t_cells
    end

    def triples_match a=[], b=[]
    # Helper method for solve_by_triples
    # Two arrays are a match if the arrays are equal or if all of the
    # values in the shorter array are present in the larger array.
      includes = true
      if a.length >= b.length
        b.each do |v| 
          includes = a.include?(v)
          break unless includes
        end
      else
        a.each do |v| 
          includes = b.include?(v)
          break unless includes
        end
      end
      includes
    end

    def block_segments
    # Helper method for solve_by_segment_values (in Board Class)
    # Every block is composed of 6 segments of 3 cells.
    # A segment is either a 3 cell row or a 3 cell column.
    # If a value is unique in a segment (i.e. it only exists in one segment) 
    # it can be eliminated as a possible solution in the column or row the segment is part of.
      segments = {}
      segments[1] = [@cells[0], @cells[1], @cells[2]]
      segments[2] = [@cells[3], @cells[4], @cells[5]]
      segments[3] = [@cells[6], @cells[7], @cells[8]]
      segments[4] = [@cells[0], @cells[3], @cells[6]]
      segments[5] = [@cells[1], @cells[4], @cells[7]]
      segments[6] = [@cells[2], @cells[5], @cells[8]]
      segments
    end

    
  end
end