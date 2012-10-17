require_relative '../lib/sudoku/collection.rb'
require 'minitest/autorun'

module Sudoku
  
  describe Collection do
    before do
      i = 1
      cells =[]
      until i == 10
        cell = Cell.new(i)
        cell.set_solution(i) if i % 2 == 0
        cells << cell
        i += 1
      end
      @collection1 = Collection.new(cells)
      @solutions = @collection1.solutions
      @collection1.cells.each {|c| c.update_cell_val(@solutions)}
      @values = @collection1.values
      @cell1 = Cell.new(10) # Test cell

      i = 0
      block = [1,2,3,10,11,12,19,20,21]
      block_cells =[]
      until i == 9
        cell = Cell.new(block[i])
        cell.set_solution(i+1) if i % 2 == 0
        block_cells << cell
        i += 1
      end
      @block = Collection.new(block_cells)
      @block_solutions = @block.solutions
      @block.cells.each {|c| c.update_cell_val(@block_solutions)}
      # @block.cells.each {|c| print "Cell ID: #{c.id} Values: #{c.values}\n"}
    end

    it "can add cells" do
      @collection1.add_cell(@cell1)
      @collection1.cells.length.must_equal 10
    end

    it "can return cells" do
      cell = @collection1.cell(2)
      cell.id.must_equal 2
      cell.must_be_instance_of(Cell)
    end

    it "has values array" do
      values_array = []
      @collection1.cells.each {|c| values_array << c.values}
      values_array.must_equal @values
    end

    it "has solutions array" do
      @solutions.must_equal [2,4,6,8]
    end

    it "can detect errors" do
      @collection1.cell(1).set_solution(2)
      @collection1.errors?.must_equal true
    end

    it "can be solved by values" do
      @collection1.solve_by_values([1,3,5,7])
      @collection1.cell(9).solution.must_equal 9
    end

    it "has unique values" do
      i = 1
      until i == 9
        @collection1.cell(i).update_cell_val([9])
        i += 2
      end
      @collection1.uniq_values.must_equal [2,4,6,8,9]
    end

    it "can be solved by solutions" do
      i = 1
      until i == 9
        @collection1.cell(i).update_cell_val([9])
        i += 2
      end
      @collection1.solve_by_solutions
      @collection1.cell(9).solution.must_equal 9  
    end

    it "has doubles" do
      @collection1.cell(1).update_cell_val([5,7,9])
      @collection1.cell(3).update_cell_val([5,7,9])
      @collection1.doubles.must_equal [1,3]
    end

    it "can be solved by doubles" do
      @collection1.cell(1).update_cell_val([5,7,9])
      @collection1.cell(3).update_cell_val([5,7,9])
      @collection1.cell(5).update_cell_val([7,9])
      @collection1.solve_by_doubles
      @collection1.cell(5).solution.must_equal 5
    end

    it "can detect a triples match" do
      a = [1,2,3]
      b = [1,3]
      @collection1.triples_match(a,b).must_equal true
    end

    it "can detect triples cells" do
      @collection1.cell(1).update_cell_val([1,3])
      @collection1.cell(3).update_cell_val([3,5])
      @collection1.cell(5).update_cell_val([1,3,5])
      triples_ids = []
      @collection1.triples_cells.each {|c| triples_ids << c.id}
      triples_ids.must_equal [1,3,5]
    end

    it "can solve by triples" do 
      @collection1.cell(1).update_cell_val([1,3])
      @collection1.cell(3).update_cell_val([3,5])
      @collection1.cell(5).update_cell_val([1,3,5])
      @collection1.cell(7).set_solution(7)
      @collection1.solve_by_triples
      @collection1.cell(9).solution.must_equal 9
    end
  end
end