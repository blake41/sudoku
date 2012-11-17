module Sudoku
  class Existing
    attr_reader :mild, :medium, :spicy, :en_fuego
    
    def initialize
      # this looks like each of these board types should be a subclass of existing.
      # your loading a whole bunch of data into memory here before we know which type of board the user wants
      # also is this really best represented by a hash? it seems awkward
      # what about an array of arrays
      # ary = [[8,2,0,3,0,0,0,0,0], [0,1,4,0,0,9,0,0,0], etc, etc]
      @mild = {}  
      @mild[1] = [8,2,0,3,0,0,0,0,0]
      @mild[2] = [0,1,4,0,0,9,0,0,0]
      @mild[3] = [0,0,0,8,0,0,2,6,1]
      @mild[4] = [0,6,0,2,0,0,4,0,0]
      @mild[5] = [7,8,0,0,0,0,0,0,0]
      @mild[6] = [0,0,0,5,9,0,0,0,0]
      @mild[7] = [0,0,0,0,8,0,0,7,5]
      @mild[8] = [0,0,0,4,3,6,0,2,0]
      @mild[9] = [0,3,0,0,0,7,0,0,0]

      @medium = {}
      @medium[1] = [0,9,0,1,0,3,0,0,0]
      @medium[2] = [0,0,5,0,0,6,0,0,2]
      @medium[3] = [0,7,0,4,5,0,0,6,0]
      @medium[4] = [0,0,0,2,0,0,1,0,0]
      @medium[5] = [0,0,7,9,0,0,0,0,0]
      @medium[6] = [0,8,0,0,1,0,0,5,0]
      @medium[7] = [0,0,2,0,0,0,0,4,0]
      @medium[8] = [0,0,0,3,0,8,0,0,1]
      @medium[9] = [0,0,0,0,0,0,0,0,7]

      @spicy = {}
      @spicy[1] = [0,0,0,6,0,0,0,0,0]
      @spicy[2] = [0,7,0,5,0,3,0,4,1]
      @spicy[3] = [0,8,0,1,9,7,0,0,0]
      @spicy[4] = [6,0,0,0,0,0,0,0,0]
      @spicy[5] = [5,3,1,7,0,0,0,0,0]
      @spicy[6] = [2,0,0,0,0,4,0,5,3]
      @spicy[7] = [0,1,3,9,7,0,0,0,0]
      @spicy[8] = [0,0,0,0,0,0,0,1,8]
      @spicy[9] = [0,0,0,0,0,0,5,0,0]

      @en_fuego = {}
      @en_fuego[1] = [0,0,0,0,0,1,0,2,0]
      @en_fuego[2] = [0,0,0,3,0,4,0,1,6]
      @en_fuego[3] = [5,0,0,0,9,0,0,0,3]
      @en_fuego[4] = [0,0,2,0,0,0,0,9,0]
      @en_fuego[5] = [0,6,0,9,0,2,0,4,0]
      @en_fuego[6] = [0,8,0,0,0,0,6,0,0]
      @en_fuego[7] = [2,0,0,0,8,0,0,0,9]
      @en_fuego[8] = [8,5,0,4,0,7,0,0,0]
      @en_fuego[9] = [0,3,0,2,0,0,0,0,0]

      @evil_game = {}
      @evil_game[1] = [0,0,0,0,0,0,0,0,3]
      @evil_game[2] = [0,0,0,4,0,0,2,8,7]
      @evil_game[3] = [2,0,0,5,9,0,0,0,0]
      @evil_game[4] = [0,0,4,0,0,0,7,3,0]
      @evil_game[5] = [5,0,0,0,2,0,0,0,6]
      @evil_game[6] = [0,9,7,0,0,0,1,0,0]
      @evil_game[7] = [0,0,0,0,5,3,0,0,1]
      @evil_game[8] = [7,5,6,0,0,4,0,0,0]
      @evil_game[9] = [3,0,0,0,0,0,0,0,0]      
    end
  end
end