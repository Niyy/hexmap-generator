class Token
    attr_accessor :position, :population, :sprite
    attr_gtk

    @next_position
    @mull_around_time
    @current_tile
    @next_tile
    @move_percent

    def initialize args, i_current_tile, i_sprite
        @args = args
        @current_tile = i_current_tile
        @sprite = i_sprite
    end


    def move
        
    end


    def chooseMullTarget
        next_position_radius ||= args.rand * @current_tile.radius
        next_position_angle ||= args.rand * 360

        @next_position =    [@current_tile.sprite.x + (Math.cos(next_position_angle * (Math::PI/180)) * next_position_radius),
                            @current_tile.sprite.y + (Math.sin(next_position_angle * (Math::PI/180)) * next_position_radius)]
        
        puts "<------------------------"
        puts next_position_radius
        puts next_position_angle
        puts @next_position
    end


    def mullAround
        x = (@next_position.sprite.x - @sprite.x)
        y = (@next_position.sprite.y - @sprite.y)
        distance = Math.sqrt((x**2 + y**2))

        if(distance <= 0.01)
            #To Do
        else
            @sprite.x += @move_percent[0]
            @sprite.y += @move_percent[1]
        end
    end
end