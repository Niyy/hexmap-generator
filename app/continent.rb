require 'app/tile.rb'
require 'app/token.rb'

# Continents hold references to areas on the grid that make up the world.
class Continent
    attr_accessor :tile_queue, :initialized, :size, :created, :consintration, :wide_adder, :root_tile
    attr_gtk

    @tiles
    @width
    @current_size
    @rng
    @finished
    @grid


    def initialize args, root, rng_gen, grid, i_size, i_consintration
        @args = args
        @root_tile = root
        @tiles = Hash.new
        @rng = rng_gen
        @size = i_size
        @current_size = 0
        @consintration = i_consintration
        @wide_adder = 0
        @created = false
        @initialized = false
        @tile_queue = Array.new
        @grid = grid
    end

    
    def spawnTile grid, next_position, queue, current_root, current_tile

        if((next_position.x >= 0 && next_position.x <= 52) && 
            (next_position.y >= 0 && next_position.y <= 21))

            if(!grid[[next_position.x, next_position.y]].tiled)
                rand_num = @rng.rand(@consintration)
                dist = (Math.sqrt((current_root.position.x - next_position.x)**2 + (current_root.position.y - (next_position.y))**2))

                if(rand_num > dist)
                    translater = rand(12)

                    if(translater <= 1)
                        level = -1
                    elsif(translater > 1 && translater < 9)
                        level = 0
                    elsif(translater >= 9)
                        level = 1
                    end
                    
                    next_level = current_tile.level + level

                    case(next_level)
                    when -1 || -2 then
                        grid[[next_position.x, next_position.y]].reinitialize "sprites/hex_plain.png", @current_size, next_level, true
                    when 0 then
                        grid[[next_position.x, next_position.y]].reinitialize "sprites/hex_plain.png", @current_size, next_level, true
                    when 1 then 
                        grid[[next_position.x, next_position.y]].reinitialize "sprites/hex_hill.png", @current_size, next_level, true
                        grid[[next_position.x, next_position.y]].sprite.h = 47
                    when 2 then
                        grid[[next_position.x, next_position.y]].reinitialize "sprites/hex_mountain.png", @current_size, next_level, true
                        grid[[next_position.x, next_position.y]].sprite.h = 38
                    end
                    

                    @tiles[[next_position.x, next_position.y]] = grid[[next_position.x, next_position.y]]

                    if(grid[[next_position.x, next_position.y]].level < -2)
                        grid[[next_position.x, next_position.y]].level = -2
                    elsif(grid[[next_position.x, next_position.y]].level > 2)
                        grid[[next_position.x, next_position.y]].level = 2
                    end

                    queue.push(grid[[next_position.x, next_position.y]])
                    current_tile.neighbor[next_position] = next_position
                end
            end

            if(!grid[[next_position.x, next_position.y]].neighbor.has_key?(current_tile.position))
                grid[[next_position.x, next_position.y]].neighbor[current_tile.position] = current_tile.position
            end
        end
    end


    def createContinent
        dist = 0;

        @root_tile.sprite.path = "sprites/hex_plain.png"
        @root_tile.age = 0
        @root_tile.level = 0
        @root_tile.tiled = true
        @tile_queue.push(@root_tile)

        @initialized = true
    end


    def addLand grid
        current_root ||= @root_tile

        if !@tile_queue.empty?
            current_tile = @tile_queue.shift
            #checkForOffShoot current_tile, current_root
            @current_size += 1
            
            spawnTile(grid, current_tile.upper_left, @tile_queue, current_root, current_tile)
            spawnTile(grid, current_tile.upper_center,  @tile_queue, current_root, current_tile)
            spawnTile(grid, current_tile.upper_right, @tile_queue, current_root, current_tile)
            spawnTile(grid, current_tile.lower_left,  @tile_queue, current_root, current_tile)
            spawnTile(grid, current_tile.lower_center,  @tile_queue, current_root, current_tile)
            spawnTile(grid, current_tile.lower_right, @tile_queue, current_root, current_tile)

            if(@current_size >= @size || @tile_queue.empty?)
                @tile_queue.clear()
                checkForUnpleasentTiles
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


    def checkForUnpleasentTiles
        checkHorizontal
        # checkVertical
        spawnToken

        puts "End Construction"
    end


    def spawnToken
        puts "spwaning"
        @args.state.token_list[@args.state.token_count] = (Token.new(@args, @grid, @root_tile,
            [@root_tile.sprite.x, @root_tile.sprite.y, 8, 8, "sprites/circle-black.png"], 0.2))
        @args.state.token_list[@args.state.token_count].chooseInternalTarget
        @args.state.token_count += 1
    end


    def checkHorizontal
        straights ||= Hash.new

        @tiles.each { |key, value| 
            straights[value.position[0]] ||= Array.new

            if(value.neighbor.size <= 4)
                straights[value.position[0]] << value
            end
        }

        straights.each { |key, value|
                if(value.size >= 4)
                    for i in 0..(value.size - 3) do
                        tile_to_release = @rng.rand(value.size - 1)

                        if(value[tile_to_release].position[0] != 0 && value[tile_to_release].position[0] != 52 &&
                            value[tile_to_release].position[1] != 0 && value[tile_to_release].position[1] != 21)
                            value[tile_to_release].remove_tile
                        end
                    end
                end
        }
    end


    def checkVertical
        vertical ||= Hash.new

        @tiles.each { |key, value| 
            vertical[value.position[1]] ||= Array.new

            if(value.neighbor.size <= 4)
                vertical[value.position[1]] << value
            end
        }

        vertical.each { |key, value|
                if(value.size >= 4)
                    for i in 0..(value.size - 4) do
                        tile_to_release = @rng.rand(value.size - 1)

                        if(value[tile_to_release].position[0] != 0 && value[tile_to_release].position[0] != 52 &&
                            value[tile_to_release].position[1] != 0 && value[tile_to_release].position[1] != 21)
                            value[tile_to_release].remove_tile
                        end
                    end
                end
        }
    end


    def findLevelSprite level, tile

        case(level)
        when -1 || -2 then
            grid[[next_position.x, next_position.y]].reinitialize "sprites/hex_plain.png", @current_size, next_level, true
        when 0 then
            grid[[next_position.x, next_position.y]].reinitialize "sprites/hex_plain.png", @current_size, next_level, true
        when 1 then 
            grid[[next_position.x, next_position.y]].reinitialize "sprites/hex_hill.png", @current_size, next_level, true
            grid[[next_position.x, next_position.y]].sprite.h = 47
        when 2 then
            grid[[next_position.x, next_position.y]].reinitialize "sprites/hex_mountain.png", @current_size, next_level, true
            grid[[next_position.x, next_position.y]].sprite.h = 38
        end

    end

    
    def serialize
        { tile_queue: tile_queue, initialized: initialized, size: size, 
            created: created, consintration: consintration, wide_adder: wide_adder }
    end

    def inspect
        serialize.to_s
    end

    def to_s
        serialize.to_s
    end

end