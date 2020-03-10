# 1280x720


class Tile
    attr_accessor :position, :tiled, :sprite
    attr_gtk

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
    attr_accessor :tile_queue, :initialized, :created

    @root_tile
    @tiles
    @width
    @size
    @current_size
    @rng
    @finished
    @tile_offset

    def initialize root, rng_gen, grid
        @root_tile = root
        @tiles = Hash.new
        @rng = rng_gen
        @size = 100
        @current_size = 0
        @tile_offset = 0
        @created = false
        @initialized = false
        @tile_queue = Array.new
    end

    def spawnTile grid, grid_x, grid_y, queue

        if(grid_x >= 0 && grid_x < 53 && grid_y >= 0 && grid_y < 22)

            rand_num = @rng.rand(@size)
            dist = (Math.sqrt( (@root_tile.position[0] - grid_x)**2 + (@root_tile.position.y - grid_y)**2) * (@size / 10))
            puts "dist #{dist}"

            if(rand_num > dist && !grid[[grid_x, grid_y]].tiled)
                grid[[grid_x, grid_y]].getSprite.path = "sprites/hex_grass.png"
                @tiles[[grid_x, grid_y]] = grid[[grid_x, grid_y]]

                queue.push(grid[[grid_x, grid_y]])
            end
        end
    end

    def createContinent
        #queue = Array.new
        dist = 0;

        @root_tile.getSprite.path = "sprites/circle-black.png"
        @root_tile.tiled = true
        #queue.push(@root_tile)
        @tile_queue.push(@root_tile)

        @initialized = true
    end

    def addLand grid
        if !@tile_queue.empty?

            cur = @tile_queue.shift
            @current_size += 1

            if (cur.position[0] % 2) == 0
                @tile_offset = 1
            else
                @tile_offset = 0
            end
            
            spawnTile(grid, (cur.position[0] - 1), (cur.position[1] + 1 - @tile_offset), @tile_queue)
            spawnTile(grid, cur.position[0], cur.position[1] + 1,  @tile_queue)
            spawnTile(grid, cur.position[0] + 1, cur.position[1] + 1 - @tile_offset, @tile_queue)
            spawnTile(grid, cur.position[0] - 1, cur.position[1] - @tile_offset,  @tile_queue)
            spawnTile(grid, cur.position[0], cur.position[1] - 1,  @tile_queue)
            spawnTile(grid, cur.position[0] + 1, cur.position[1] - @tile_offset, @tile_queue)

            if(@current_size >= @size)
                @tile_queue.clear()
                @created = true;
            end
        end
    end
end


$rng = Random.new
$grid = HexGrid.new
$continentOne
$continentTwo

def tick args
    $grid.args = args   
    $grid.setUpGrid
    root_x ||= $rng.rand(52)
    root_y ||= $rng.rand(21)

    $continentOne ||= Continet.new($grid.grid_positions[[root_x, root_y]], $rng, $grid.getGrid)

    if(!$continentOne.initialized)
        $continentOne.createContinent

        root_x = $rng.rand(52)
        root_y = $rng.rand(21)

        puts "Did continentOne creation"
    end
    if(!$continentOne.created)
        $continentOne.addLand $grid.grid_positions
    end


    $continentTwo ||= Continet.new($grid.getHex(root_x, root_y), $rng, $grid.getGrid)

    if(!$continentTwo.initialized)
        root_x = $rng.rand(52)
        root_y = $rng.rand(21)

        $continentTwo.createContinent
    elsif(!$continentTwo.created)
        $continentTwo.addLand $grid.grid_positions
    end

    $grid.draw
    $grid.input
end
