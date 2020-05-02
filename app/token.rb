class token
    attr_accessor :position, :population, :sprite
    gtk_attr

    @next_position
    @mull_around_time
    @mull_around_time_current
    @current_tile
    @next_tile

    def intitialize
        @move_percent = [@sprite.x, @sprite.y]
    end


    def move
        
    end


    def mullAround
        x = (@next_position.sprite.x - @sprite.x)
        y = (@next_position.sprite.y - @sprite.y)
        distance = Math.sqrt((x**2 + y**2))

        if(distance <= 0.01)
            adder_x = rng.Random(current_tile.sprite.w)
            adder_y = rng.Random(current_tile.sprite.h)

            @next_position = [@current_tile.sprite.x + adder_x, @current_tile.sprite.y + adder_y] 
            @move_percent = [x, y]
        else
            @sprite.x += @move_percent[0]
            @sprite.y += @move_percent[1]
    end
end