# Token class is the base class for all other classes that will move across the map.
class Token
    attr_accessor :position, :population, :sprite, :center, :speed, :grid
    attr_gtk

    @next_position
    @mull_around_time
    @current_tile
    @next_tile
    @move_percent
    @mull_count

    def initialize args, grid, i_current_tile, i_sprite, i_speed
        @args = args
        @grid = grid
        @current_tile = i_current_tile
        @sprite = i_sprite
        @center = [(@sprite.w / 2) + @sprite.x, (@sprite.h / 2) + @sprite.y]
        @speed = i_speed
        @mull_count = args.rand * 6
    end


    def chooseMullTarget
        next_position_radius ||= args.rand * @current_tile.radius
        next_position_angle ||= args.rand * 360

        @next_position =    [@current_tile.center[0] + (Math.cos(next_position_angle * (Math::PI/180)) * next_position_radius),
                            @current_tile.center[1] + (Math.sin(next_position_angle * (Math::PI/180)) * next_position_radius)]

        x = (@next_position[0] - @center[0])
        y = (@next_position[1] - @center[1])
        magnitude = Math.sqrt(x**2 + y**2)

        x = x / magnitude
        y = y / magnitude

        @move_percent = [x * @speed, y * @speed]
    end


    def mullAround

        if !@next_position.nil?
            x = (@next_position[0] - @center[0])
            y = (@next_position[1] - @center[1])
            distance = Math.sqrt((x**2 + y**2))

            if(distance <= @move_percent[0].abs || distance <= @move_percent[1].abs)
                if (@mull_count <= 0)
                    chooseNextTile
                end

                chooseMullTarget
                @mull_count -= 1
                puts @mull_count
            else
                @sprite.x += @move_percent[0]
                @sprite.y += @move_percent[1]
            end

            @center = [(@sprite.w / 2) + @sprite.x, (@sprite.h / 2) + @sprite.y]
        end
    end

    def chooseNextTile
        possible_locations = Array.new

        if !@current_tile.neighbor.empty?
            @current_tile.neighbor.each_value { |a_neighbor|
                # puts "some sprite: #{a_neighbor}------------->"

                if @grid[a_neighbor].tiled
                    possible_locations << @grid[a_neighbor]
                end
            }
        end

        # puts "size: #{possible_locations.size}"  
        # puts "#{@current_tile}<----------"

        @mull_count = args.rand * 6

        if possible_locations.size > 0 
            @current_tile = possible_locations[(args.rand * possible_locations.size).floor]
        end
    end

    def serialize                                                                 
        { position: position, population: population, sprite: sprite, center: center, 
        speed: speed }                                                                
    end

    def inspect                                                                   
        serialize.to_s
    end
    
    def to_s
        serialize.to_s
    end
    
end