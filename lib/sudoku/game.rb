require_relative 'board'
require_relative 'populated_board'
require 'debugger'
module Sudoku
  class Game
    # these are used so you can call self.board, but i dont think you ever do that
    attr_accessor :board, :beginning_board, :player

    def initialize
      @board = Board.new
      @beginning_board = Board.new
    end

  ###################################################################
  #################### CORE GAME PLAYING METHODS ####################
  ###################################################################

    def play
      self.game_setup
    end

    def quit_game
      puts "Thanks for playing."
    end

    def game_setup
    # Existing board allows user to play a pre-populated board.
    # Creating his/her own board forces user to input 9 rows of values representing
    # the beginning board
    # No validations exist to ensure a user generated board is valid or solvable.
      puts "Hi. Welcome to the Sudoku Arena.  Would you like to play an existing board or create your own?  ('existing' / 'own')"
# not sure what the loop is here for, the gets method is a "blocking" call. meaning it will sit and wait for input and only 
# continue execution once it gets input, so remove the loop and break
      loop do
        type = gets.chomp.downcase
        case type
        when 'existing'
          self.setup_existing_board
          break
        when 'own'
          self.custom_board_greeting
          break
        when 'quit'
          self.quit_game
          break
        else
          puts "Please type 'existing' or 'own' or 'quit'."
        end
      end
    end

    def setup_existing_board
    # User chooses difficulty level.
    # so board should = Mild.new 
    # class Mild < Existing
    #   def init
    #     whatever it looks like
    #   end
    # end

      board = Existing.new
      puts "\n" << "So you want to use an existing board.  What level are you in the mood for?  ('mild', 'medium', 'spicy', or 'en fuego')"
      loop do
        difficulty = gets.chomp.downcase
        case difficulty
        when 'mild'
# its not clear to me why populate board takes a type of board and then converts it to the board data structure with cells
# shouldnt the preset boards already be set up correctly with cells
          @board.populate_board(board.mild)
          self.set_board
          break
        when 'medium'
          @board.populate_board(board.medium)
          self.set_board
          break
        when 'spicy'
          @board.populate_board(board.spicy)
          self.set_board
          break
        when 'en fuego'
          @board.populate_board(board.en_fuego)
          self.set_board
          break
        else
          puts "\n" << "Sorry. I didn't get that.  What are you in the mood for?  ('mild', 'medium', 'spicy', or 'en fuego')"
        end
      end
    end

    def custom_board_greeting
      puts "\n" << "Let's add one row at a time.  Each row should be in the following format with blank cells as '0's:"
      puts "0,0,0,0,0,0,0,0,0 would create a completely blank row."
      puts "0,2,0,3,0,0,8,0,0 would create a row with a few numbers populated to start."
      puts "\n" << "Let's give it a shot. If you change your mind, just type 'existing' to play an existing board or 'quit' to quit."
      self.setup_custom_board
    end

    def setup_custom_board
      row_id = 1
      loop do
        response = gets.chomp
        case response
        when 'quit'
          self.quit_game
          break
        when 'existing'
          self.setup_existing_board
          break
        else
          row = self.parse_row(response)
          if self.validate_row(row)
            self.add_row(row, row_id)
            row_id += 1
            if row_id == 10
              self.set_board
              break
            else
              puts "Thanks.  Go ahead and add row " << "#{row_id}."
            end
          else
            puts "That wasn't quite right.  Try again."
          end
        end
      end
    end

    def set_board
    # Check for duplicate solutions in any row, column or block
    # No validation board is actually solvable
    # Creates copy of board in case user wants to start over 
      if @board.board_errors?
        @board.print_board
        puts "\n" << "Looks like you have some errors in the board.  Remember no column, row or block can have the same number.  Let's start over."
        self.revisit_custom_board
      else
        puts "The beginning board board is set."
        self.create_beginning_board
        @board.print_board
        self.start_playing
      end
    end

    def create_beginning_board
      # dont use instance variable set, you should have a getter and setter to do this
      # your using ruby tricks to get around your objects api
      debugger
      beginning_cells = []
      @board.cells.each {|c| beginning_cells << c.dup}
      # couldnt we just call @beginning_board.clone (im not 100 on clone vs dup)
      # i also think whenever you set @board, you should just set @beginning board to the same thing and 
      # these boards should be all preset at that time
      @beginning_board.instance_variable_set(:@cells, beginning_cells)
    end

    def start_playing
      puts "\n" << "Let's start playing."
      loop do
        puts "\n" << "To set a cell's value type 'set value'.  You can also 'print board', 'check answers', 'solve the puzzle' 'start over' or 'quit'."
        answer = gets.chomp.downcase
        case answer
        when 'set value'
          self.get_active_cell_id
        when 'print board'
          puts "\n" << "The Current Board"
          @board.print_board
        when 'check answers'
          @board.solved?
        when 'solve the puzzle'
          @beginning_board.solve
          break
        when 'start over'
          self.game_setup
          break
        when 'quit'
          self.quit_game
          break
        else
          puts "\n" << "Sorry.  I didn't get that."
        end
      end
    end

  ##################################################################
  ################## CUSTOM BOARD HELPER METHODS ###################
  ##################################################################

    def revisit_custom_board
    # Revisit beginning sequence for user generated board if previous user generated board
    # contained basic errors (i.e. duplicate solutions in a collection)
      puts "Each row should be in the following format with blank cells as '0's:"
      puts "0,0,0,0,0,0,0,0,0 would create a completely blank row."
      puts "0,2,0,3,0,0,8,0,0 would create a row with a few numbers populated to start."
      puts "\n"
      self.setup_custom_board
    end

# this is stylistic but i really prefer parenthesis around arguments to a function
    def add_row row=[], row_id
      @board.add_board_row(row, row_id)
    end

    def parse_row str 
    # Helper method for basic row validation
      row = []
      str.split(',').each {|v| row << v.to_i}
      row
      # tap is cool to do this
      # row = [].tap do |array|
        # whatever
      # end
    end

    def validate_row row
    # Basic validation for user generated row.
    # we don't really ever validate types in ruby, we valid the interface
    # so check like row.respond_to?("length") or whatever methods you want the object to respond to
    # we dont care in ruby what class an object is, just that it implements the methods we want to call on it
      return false unless row.class == Array
      # dont indent, your not actually in any block
      return false unless row.length == 9
      row.each do |value|
        # so maybe here you should check that things respond to + or whatever you care about for sudoku
        return false unless value.class == Fixnum
        return false unless value >=0 && value <= 9
      end
      # also you can name these checks and do something like this
      # ["validate_class", "validate_range", "etc"].each do |validation|
      #   return false unless self.send("validation")
      # end
      # this way it's clearer what the checks are if they're well named and you can easily add more to the array
    end

  #################################################################
  ################### GAME PLAY HELPER METHODS ####################
  #################################################################

    def get_active_cell_id
    # Get cell ID user wishes to update.  Provide row and column information to confirm.
      puts "\n" << "Let's set the cell's value using its Location ID.  Location IDs start at 1 (upper left corner) and end at 81 (lower right corner) moving left to right and top to bottom."
      loop do
        puts "What is the ID of the cell you want to set?"
        answer = gets.chomp.downcase.to_i
        if answer.between?(1,81)
          # use puts here?
          print "\n" << "Cell #{answer} is in column #{@board.cell(answer).col_head_id} and row #{@board.cell(answer).row_head_id/9+1}.  "
          if @board.cell(answer).solution.nil?
            puts "It is currently unsolved."
          else
            puts "The cell's solution is currently #{@board.cell(answer).solution}."
          end
          self.confirm_id_selection(answer)
          break
        else
          puts "\n" << "The cell ID must be between 1 and 81."
        end
      end
    end
      
    def confirm_id_selection id
    # Provide user ability to confirm or change selection.
      puts "\n" << "Is this the cell you want to set? ('yes' / 'no')"
      loop do
        response = gets.chomp.downcase 
        case response
        when 'no'
          self.get_active_cell_id
          break
        when 'yes'
          self.set_cell_value(id)
          break
        else
         puts "\n" << "Sorry.  I didn't get that.  Please type 'yes' or 'no'."
        end 
      end
    end

    def set_cell_value id
    # Validates input value is between 1 and 9
    # Needs validation an integer and not a string or other is input 
      loop do
        puts "What is the value you would like to set cell #{id} to?"
        value = gets.chomp.downcase.to_i
        if value.between?(1,9)
          @board.cell(id).set_solution(value)
          puts "Here is the updated board."
          @board.print_board
          break
        else
          puts "\n" << "The cell value must be between 1 and 9."
        end
      end
    end
  end
end