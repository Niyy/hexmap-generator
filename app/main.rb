# 1280x720


class Tile
    attr_accessor :position
    attr_gtk

    @position
    @sprite
    @dimensions

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


    def getDimensions
        return [@sprite.w, @sprite.h]
    end
end


# Grid will hold data on all the tiles in the realm.
# This will be used for a reference for contentents.
class HexGrid
    attr_gtk

    @grid_positions
    @set_up

    def setUpGrid

        if @grid_positions.nil?
            @grid_positions ||= Hash.new
            offset = 32 / 2

            for i in 0..52 do
                for j in 0..21 do
                    x = i * 24
                    y = (j * 30) + 32 - offset
                    @grid_positions[[i, j]] = Tile.new([i, j], [x, y, 32, 32, "sprites/hex_outline.png"])
                end
        
                if offset == 32 / 2
                    offset = 0
                else
                    offset = 32 / 2
                end
            end

            @set_up ||= true;
        end
    end


    def draw
        for i in 0..52 do
            for j in 0..21 do
                outputs.sprites << @grid_positions[[i, j]].getSprite
            end
        end
        outputs.sprites << state.current_mouse_pos
    end


    def input
        if inputs.mouse.click
            odd_column = false

            x = ((inputs.mouse.click.x.floor() / 24)).floor()
            y = (inputs.mouse.click.y.floor() / 30).floor()

            if x % 2 > 0
                y = y - 1
                odd_column = true
            end

            mouse_position = @grid_positions[[x, y]].getSprite

            if mouse_position.y > inputs.mouse.click.y && !odd_column
                 y = y - 1
                 mouse_position = @grid_positions[[x, y]].getSprite
                 puts "Does this shoot"
             end

            state.current_mouse_pos = [mouse_position.x, mouse_position.y, mouse_position.w, mouse_position.h, "sprites/circle-orange.png"]
        end
    end


    def getHex i, j
        return @grid_positions[[i, j]].getSprite
    end


    def getGrid
        return @grid_positions
    end
end


class Continet
    @root_tile
    @tiles
    @width
    @size

    def initialize root, grid
        rng = Random.new

        @root_tile = root
        @tiles = Hash.new

        root.path = "sprites/hex_grass.png"
        cur = root

        for i in 0..3 do
            roll = rng.rand(6)

            case roll
            when 0
                grid[[cur.x - 1, cur.y + 1]].sprite.path = root.path
            when 1
                grid[[cur.x, cur.y + 1]].sprite.path = root.path
            when 2
                grid[[cur.x + 1, cur.y + 1]].sprite.path = root.path
            end
        end
    end
end

$rng = Random.new
root_x = $rng.rand(52)
root_y = $rng.rand(21)
$grid = HexGrid.new
$continet

def tick args
    $grid.args = args
    $grid.setUpGrid
    root_x ||= $rng.rand(52)
    root_y ||= $rng.rand(21)
    #$continet ||= Continet.new($grid.getHex(root_x, root_y), $grid.getGrid)

    $grid.draw
    $grid.input
end
