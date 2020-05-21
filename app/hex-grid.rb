require 'app/tile.rb'

# Grid will hold data on all the tiles in the realm.
# This will be used for a reference for contentents.
class HexGrid
    attr_accessor :grid_positions, :width, :height, :initial_sprite
    attr_gtk

    @set_up

    def setUpGrid

        if @grid_positions.nil?
            @width ||= 32
            @height ||= 30
            @grid_positions ||= Hash.new
            offset = 32 / 2

            state.current_mouse_pos = [-100, -100, 1, 1, "sprites/circle-orange.png"]

            for i in 0..52 do
                for j in 0..21 do
                    x = i * 24
                    y = (j * 30) + 32 - offset
                    i_sprite = [x, y, @width, @height, "sprites/hex_water.png"]
                    @initial_sprite = [x, y, @width, @height, "sprites/hex_water.png"]
                    @grid_positions[[i, j]] = Tile.new([i, j], i_sprite, @initial_sprite)
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
        if(!@grid_positions.nil?)
            for i in 0..52 do
                for j in 0..21 do
                    tiling =  @grid_positions[[52 - i, 21 - j]]
                    outputs.sprites << tiling.sprite
                    #outputs.labels << [tiling.sprite.x + 2, tiling.sprite.y + 17, "#{52 - i},#{21 - j}", -6]
                end
            end
            
            if(!state.current_mouse_pos.x != -100)
                outputs.sprites << state.current_mouse_pos
            end
        end
    end

    def clearGrid
        for i in 0..52 do
            for j in 0..21 do
                @grid_positions[[i, j]].reinitialize_full initial_sprite.path, initial_sprite[2], initial_sprite[3], 0, 0, false
            end
        end
    end

    def input
        if(!@grid_positions.nil?)
            if inputs.mouse.click
                odd_column = false

                x = ((inputs.mouse.click.x.floor() / 24)).floor()
                y = (inputs.mouse.click.y.floor() / 30).floor()

                if x % 2 > 0
                    y = y - 1
                    odd_column = true
                end
                
                if(x < 53 && x >= 0 && y < 22 && y >= 0)
                    mouse_position = @grid_positions[[x, y]].sprite

                    if mouse_position.y > inputs.mouse.click.y && !odd_column
                        y = y - 1
                        mouse_position = @grid_positions[[x, y]].sprite
                    end

                    state.current_mouse_pos = [mouse_position.x, mouse_position.y, 
                                                mouse_position.w, mouse_position.h, "sprites/circle-orange.png"]
                else
                    state.current_mouse_pos = [-100, -100, 1, 1, "sprites/circle-orange.png"]
                end
            end
        end
    end


    def serialize
        { grid_positions: grid_positions, width: width, height: height }
    end


    def inspect
        serialize.to_s
    end


    def to_s
        serialize.to_s
    end
end