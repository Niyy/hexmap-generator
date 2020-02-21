# 1280x720

# Grid will hold data on all the tiles in the realm.
# This will be used for a reference for contentents.
class HexGrid
    attr_gtk
    @grid_positions

    def setUpGrid
        @grid_positions ||= Hash.new
        offset = 32 / 2

        for i in 0..52 do
            for j in 0..21 do
                x = i * 24
                y = (j * 30) + 32 - offset
                @grid_positions[[i, j]] = Tile.new([i,j], [x, y, 32, 32, "sprites/hex_outline.png"])
            end
    
            if offset == 32 / 2
                offset = 0
            else
                offset = 32 / 2
            end
        end
    end


    def draw
        for i in 0..52 do
            for j in 0..21 do
                outputs.sprites << @grid_positions[[i, j]].getSprite
            end
        end
    end


    def input
        puts "x: #{inputs.mouse.x}"
        puts "y: #{inputs.mouse.y}"
    end
end


class Tile
    attr_gtk
    @position
    @sprite

    def initialize i_position, i_sprite
        @position = i_position
        @sprite = i_sprite
    end


    def getSprite
        return @sprite
    end
end


$grid = HexGrid.new

def tick args
    $grid.args = args
    $grid.setUpGrid

    $grid.draw
    $grid.input
end