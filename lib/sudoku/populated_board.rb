module Sudoku
  class Existing
    attr_reader :easy_game, :moderate_game, :demanding_game, :tough_game, :evil_game
    
    def initialize
      @easy_game = {}  
      @easy_game[1] = [8,2,0,3,0,0,0,0,0]
      @easy_game[2] = [0,1,4,0,0,9,0,0,0]
      @easy_game[3] = [0,0,0,8,0,0,2,6,1]
      @easy_game[4] = [0,6,0,2,0,0,4,0,0]
      @easy_game[5] = [7,8,0,0,0,0,0,0,0]
      @easy_game[6] = [0,0,0,5,9,0,0,0,0]
      @easy_game[7] = [0,0,0,0,8,0,0,7,5]
      @easy_game[8] = [0,0,0,4,3,6,0,2,0]
      @easy_game[9] = [0,3,0,0,0,7,0,0,0]

      @moderate_game = {}
      @moderate_game[1] = [0,9,0,1,0,3,0,0,0]
      @moderate_game[2] = [0,0,5,0,0,6,0,0,2]
      @moderate_game[3] = [0,7,0,4,5,0,0,6,0]
      @moderate_game[4] = [0,0,0,2,0,0,1,0,0]
      @moderate_game[5] = [0,0,7,9,0,0,0,0,0]
      @moderate_game[6] = [0,8,0,0,1,0,0,5,0]
      @moderate_game[7] = [0,0,2,0,0,0,0,4,0]
      @moderate_game[8] = [0,0,0,3,0,8,0,0,1]
      @moderate_game[9] = [0,0,0,0,0,0,0,0,7]

      @demanding_game = {}
      @demanding_game[1] = [0,0,0,6,0,0,0,0,0]
      @demanding_game[2] = [0,7,0,5,0,3,0,4,1]
      @demanding_game[3] = [0,8,0,1,9,7,0,0,0]
      @demanding_game[4] = [6,0,0,0,0,0,0,0,0]
      @demanding_game[5] = [5,3,1,7,0,0,0,0,0]
      @demanding_game[6] = [2,0,0,0,0,4,0,5,3]
      @demanding_game[7] = [0,1,3,9,7,0,0,0,0]
      @demanding_game[8] = [0,0,0,0,0,0,0,1,8]
      @demanding_game[9] = [0,0,0,0,0,0,5,0,0]

      @tough_game = {}
      @tough_game[1] = [0,0,0,0,0,1,0,2,0]
      @tough_game[2] = [0,0,0,3,0,4,0,1,6]
      @tough_game[3] = [5,0,0,0,9,0,0,0,3]
      @tough_game[4] = [0,0,2,0,0,0,0,9,0]
      @tough_game[5] = [0,6,0,9,0,2,0,4,0]
      @tough_game[6] = [0,8,0,0,0,0,6,0,0]
      @tough_game[7] = [2,0,0,0,8,0,0,0,9]
      @tough_game[8] = [8,5,0,4,0,7,0,0,0]
      @tough_game[9] = [0,3,0,2,0,0,0,0,0]

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