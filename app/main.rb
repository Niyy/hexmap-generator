# 1280x720


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


    def getPosition
        return @position
    end
end


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
                @grid_positions[[i, j]] = Tile.new([x+16,j+16], [x, y, 32, 32, "sprites/hex_outline.png"])
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
        outputs.sprites << state.mouse_position
    end


    def input
        if inputs.mouse.click
           x = ((inputs.mouse.click.x / 32)).floor()
           y = (inputs.mouse.click.y / 32).floor()
           puts "X: #{x} Y: #{y}"
           state.mouse_position = [x, y, 10, 10, "sprites/circle-orange.png"]
        end
    end
end


$grid = HexGrid.new

def tick args
    $grid.args = args
    $grid.setUpGrid

    $grid.draw
    $grid.input
end
