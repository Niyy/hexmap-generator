# 1280x720


class Tile
    attr_accessor :position, :tiled, :sprite
    attr_gtk

    def initialize i_position, i_sprite
        @position = i_position
        @sprite = i_sprite
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
                outputs.sprites << @grid_positions[[i, j]].sprite
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

            mouse_position = @grid_positions[[x, y]].sprite

            if mouse_position.y > inputs.mouse.click.y && !odd_column
                 y = y - 1
                 mouse_position = @grid_positions[[x, y]].sprite
             end

            state.current_mouse_pos = [mouse_position.x, mouse_position.y, mouse_position.w, mouse_position.h, "sprites/circle-orange.png"]
        end
    end
end


class Continent
    attr_accessor :tile_queue, :initialized, :created, :long_adder, :wide_adder

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
        @size = 50
        @current_size = 0
        @tile_offset = 0
        @long_adder = 0
        @wide_adder = 0
        @created = false
        @initialized = false
        @tile_queue = Array.new
    end

    def spawnTile grid, grid_x, grid_y, queue, current

        if(grid_x >= 0 && grid_x < 53 && grid_y >= 0 && grid_y < 22)

            rand_num = @rng.rand(@size)
            dist = (Math.sqrt( (current.position[0] - grid_x)**2 + (current.position.y - grid_y)**2) * (@size / 5))

            if(rand_num > dist && !grid[[grid_x, grid_y]].tiled)
                grid[[grid_x, grid_y]].sprite.path = "sprites/hex_grass.png"
                @tiles[[grid_x, grid_y]] = grid[[grid_x, grid_y]]

                queue.push(grid[[grid_x, grid_y]])
            end
        end
    end

    def createContinent
        #queue = Array.new
        dist = 0;

        @root_tile.sprite.path = "sprites/circle-black.png"
        @root_tile.tiled = true
        #queue.push(@root_tile)
        @tile_queue.push(@root_tile)

        @initialized = true
    end

    def addLand grid
        if !@tile_queue.empty?
            current_root ||= @root_tile
            current_tile = @tile_queue.shift
            checkForOffShoot current_tile, current_root
            @current_size += 1

            if (current_tile.position[0] % 2) == 0
                @tile_offset = 1
            else
                @tile_offset = 0
            end
            
            spawnTile(grid, (current_tile.position[0] - 1), (current_tile.position[1] + 1 - @tile_offset), @tile_queue, current_root)
            spawnTile(grid, current_tile.position[0], current_tile.position[1] + 1,  @tile_queue, current_root)
            spawnTile(grid, current_tile.position[0] + 1, current_tile.position[1] + 1 - @tile_offset, @tile_queue, current_root)
            spawnTile(grid, current_tile.position[0] - 1, current_tile.position[1] - @tile_offset,  @tile_queue, current_root)
            spawnTile(grid, current_tile.position[0], current_tile.position[1] - 1,  @tile_queue, current_root)
            spawnTile(grid, current_tile.position[0] + 1, current_tile.position[1] - @tile_offset, @tile_queue, current_root)

            if(@current_size >= @size)
                @tile_queue.clear()
                @created = true;
            end
        end
    end

    def checkForOffShoot current_tile, current_root
        rand_num = @rng.rand(100)

        if(rand_num >= 0.90)
            current_root.sprite.path = "sprites/hex_grass.png"
            current_root = current_tile
            current_tile.sprite.path = "sprites/circle-blue.png"
            puts "Changed root too #{current_root.position}"
        end
    end
end


$rng = Random.new
$grid = HexGrid.new
$continents

def tick args
    $grid.args = args   
    $grid.setUpGrid

    if($continents.nil?)
        $continents ||= Array.new()

        for i in 1..5 do
            root_x = $rng.rand(52)
            root_y = $rng.rand(21)

            $continents.push Continent.new($grid.grid_positions[[root_x, root_y]], $rng, $grid.grid_positions)
            $continents.last.createContinent
        end
    end

    for i in 0..4 do
        puts "huhuh"
        if(!$continents[i].created)
            $continents[i].addLand $grid.grid_positions
        end
        puts "haha"
    end

    $grid.draw
    $grid.input
end
