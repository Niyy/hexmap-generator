# 1280x720

# Age - 0 is the oldest parts of the continent. The greater the age the younder it is
# Level - Negative values are bellow sea level, positive values are above sea level, and zero is beaches
class Tile
    attr_accessor :position, :tiled, :sprite, :neighbor, :age, :level
    attr_gtk

    def initialize i_position, i_sprite
        @position = i_position
        @sprite = i_sprite
        @neighbor = Array.new
        @tiled = false
    end

    def reinitialize sprite, age, level, tiled
        @sprite.path = sprite
        @age = age
        @level = level
        @tiled = tiled
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
                tiling =  @grid_positions[[i, j]]
                outputs.sprites << tiling.sprite
                outputs.labels << [tiling.sprite.x + 2, tiling.sprite.y + 17, "#{tiling.level}, #{tiling.age}", -6]
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
    attr_accessor :tile_queue, :initialized, :created, :consintration, :wide_adder

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
        @consintration = 4
        @wide_adder = 0
        @created = false
        @initialized = false
        @tile_queue = Array.new
    end

    def spawnTile grid, grid_x, grid_y, queue, current_root, current_tile

        if(grid_x < 0)
            grid_x = 52 + grid_x
        elsif(grid_x >= 53)
            grid_x = grid_x - 52
        end

        if(grid_y < 0)
            grid_y = 21 + grid_y
        elsif(grid_y >= 22)
            grid_y = grid_y - 21
        end

            if(!grid[[grid_x, grid_y]].tiled)
                rand_num = @rng.rand(@consintration)
                dist = (Math.sqrt((current_root.position.x - grid_x)**2 + (current_root.position.y - grid_y)**2))
                puts "#{rand_num} > #{dist}"

                if(rand_num > dist)
                    translater = rand(3)

                    case(translater)
                    when 0 then level = -1
                    when 1 then level = 0
                    when 2 then level = 1
                    end
                    
                    grid[[grid_x, grid_y]].reinitialize "sprites/hex_grass.png", @current_size, (current_tile.level + level), true
                    current_tile.neighbor << grid[[grid_x, grid_y]]
                    @tiles[[grid_x, grid_y]] = grid[[grid_x, grid_y]]

                    if(grid[[grid_x, grid_y]].level < -2)
                        grid[[grid_x, grid_y]].level = -2
                    elsif(grid[[grid_x, grid_y]].level > 2)
                        grid[[grid_x, grid_y]].level = 2
                    end

                    queue.push(grid[[grid_x, grid_y]])
                end
            else
                current_tile.neighbor << grid[[grid_x, grid_y]]
            end
        elsif(grid[[grid_x, grid_y]].tiled)
            
        end
    end

    def createContinent
        dist = 0;

        @root_tile.sprite.path = "sprites/circle-black.png"
        @root_tile.age = 0
        @root_tile.level = @rng.rand(5)
        @root_tile.tiled = true
        @tile_queue.push(@root_tile)

        @initialized = true
    end

    def addLand grid
        current_root ||= @root_tile

        if !@tile_queue.empty?
            current_tile = @tile_queue.shift
            checkForOffShoot current_tile, current_root
            @current_size += 1

            if (current_tile.position[0] % 2) == 0
                @tile_offset = 1
            else
                @tile_offset = 0
            end
            
            spawnTile(grid, (current_tile.position[0] - 1), (current_tile.position[1] + 1 - @tile_offset), @tile_queue, current_root, current_tile)
            spawnTile(grid, current_tile.position[0], current_tile.position[1] + 1,  @tile_queue, current_root, current_tile)
            spawnTile(grid, current_tile.position[0] + 1, current_tile.position[1] + 1 - @tile_offset, @tile_queue, current_root, current_tile)
            spawnTile(grid, current_tile.position[0] - 1, current_tile.position[1] - @tile_offset,  @tile_queue, current_root, current_tile)
            spawnTile(grid, current_tile.position[0], current_tile.position[1] - 1,  @tile_queue, current_root, current_tile)
            spawnTile(grid, current_tile.position[0] + 1, current_tile.position[1] - @tile_offset, @tile_queue, current_root, current_tile)

            if(@current_size >= @size)
                @tile_queue.clear()
                @created = true;
            end
        end
    end

    def checkForOffShoot current_tile, current_root
        rand_num = @rng.rand(100)

        if(rand_num <= 40)
            current_root.sprite.path = "sprites/hex_grass.png"
            current_root = current_tile
            current_root.sprite.path = "sprites/circle-blue.png"
        end
    end

    def fallIntoTheSea
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
        if(!$continents[i].created)
            $continents[i].addLand $grid.grid_positions
        end
    end

    $grid.input
    $grid.draw
end
