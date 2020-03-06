# 1280x720


class Tile
    attr_accessor :position
    attr_gtk

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
    attr_accessor :grid_positions
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
        return @grid_positions[[i, j]]
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
    @created

    def initialize root, grid
        @root_tile = root
        @tiles = Hash.new
        @size = 6
        @created = false;
    end

    def landCreation grid, grid_x, grid_y, queue
        rng = Random.new

        if(rng.rand(1) < 0.8)
            grid[[grid_x, grid_y]].getSprite.path = "sprites/circle-black.png"

            added_land = [grid_x, grid_y]
            queue.push(added_land)
        end
    end

    def continetCreator grid
        queue = Array.new

        @root_tile.getSprite.path = "sprites/hex_grass.png"
        queue.push(@root_tile)
        tile_offset = 0


        while !queue.empty?
            cur = queue.pop

            if (cur.position[0] % 2) == 0
                tile_offset = 1
            else
                tile_offset = 0
            end
            
            landCreation(grid, (cur.position[0] - 1), (cur.position[1] + 1 - tile_offset), queue)
            # landCreation(grid, cur.position[0], cur.position[1] + 1, queue)
            # landCreation(grid, cur.position[0] + 1, cur.position[1] + 1 - tile_offset, queue)
            # landCreation(grid, cur.position[0] - 1, cur.position[1] - tile_offset, queue)
            # landCreation(grid, cur.position[0], cur.position[1] - 1, queue)
            # landCreation(grid, cur.position[0] + 1, cur.position[1] - tile_offset, queue)
        end

        @created = true;
    end

    def getCreated
        return @created
    end

end


$rng = Random.new
$grid = HexGrid.new
$continet

def tick args
    $grid.args = args   
    $grid.setUpGrid
    root_x ||= $rng.rand(52)
    root_y ||= $rng.rand(21)

    $continet ||= Continet.new($grid.getHex(4, 4), $grid.getGrid)

    if(!$continet.getCreated)
        $continet.continetCreator $grid.getGrid
    end

    $grid.draw
    $grid.input
end
