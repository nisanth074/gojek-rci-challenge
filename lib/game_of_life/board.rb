require "game_of_life/cell"

class GameOfLife
  class Board
    # Create a board from the input string
    def self.from_string(board_string)
      board_length = board_string.split("\n").count
      board = new(board_length)

      board_string.split("\n").each_with_index do |row, x|
        row.split(" ").each_with_index do |char, y|
          cell_state, cell_position = char, [x, y]
          cell_class = cell_state == '1' ? LivingCell : DeadCell
          board.add_cell(cell_class.new(cell_position, board))
        end
      end

      board
    end

    def initialize(board_length)
      @board_length = board_length
    end

    def length
      @board_length
    end

    def each_cell
      (0..(@board_length - 1)).each do |x|
        (0..(@board_length - 1)).each do |y|
          yield cell_at_position([x, y])
        end
      end
    end

    def add_cell(cell)
      board_hash[cell.position] = cell if cell.alive?
    end

    def cell_at_position(cell_position)
      board_hash[cell_position]
    end

    # Convert board to a displayable string
    def to_s
      (0..(@board_length - 1)).map do |x|
        (0..(@board_length - 1)).map do |y|
          cell_position = [x, y]
          cell = board_hash[cell_position]
          cell.to_s
        end.join(" ")
      end.join("\n") + "\n"
    end

    private

    def board_hash
      @board_hash ||= Hash.new { |_, cell_position| DeadCell.new(cell_position, self) } # Board hash stores only living cells
    end
  end
end
