# Age - 0 is the oldest parts of the continent. The greater the age the younder it is
# Level - Negative values are bellow sea level, positive values are above sea level, and zero is beaches
class Tile
    attr_accessor   :position, :tiled, :sprite, :top_sprite, :neighbor, :age, :level, :tile_offset,
                    :radius
    attr_gtk

    def initialize i_position, i_sprite
        @position = i_position
        @sprite = i_sprite
        @neighbor = Hash.new
        @tiled = false
        @tile_offset = 0
        @radius = i_sprite.x / 2
    end

    def reinitialize sprite, age, level, tiled
        @sprite.path = sprite
        @age = age
        @level = level
        @tiled = tiled
    end


    def upper_center
        return [position[0], position[1] + 1]
    end

    def lower_center
        return [position[0], position[1] - 1]
    end

    def lower_left
        tile_offset = 0

        if (@position[0] % 2) == 0
            tile_offset = 1
        end

        return [position[0] - 1, position[1] - tile_offset]
    end 

    def upper_left
        tile_offset = 0

        if (@position[0] % 2) == 0
            tile_offset = 1
        end

        return [position[0] + 1, position[1] + 1 - tile_offset]
    end

    def lower_right
        tile_offset = 0

        if (@position[0] % 2) == 0
            tile_offset = 1
        end

        return [position[0] + 1, position[1] - tile_offset]
    end

    def upper_right
        tile_offset = 0

        if (@position[0] % 2) == 0
            tile_offset = 1
        end

        return [position[0] - 1, position[1] + 1 - tile_offset]
    end

    def serialize
        { position: position, tiled: tiled, sprite: sprite, top_sprite: top_sprite, 
            neighbor: neighbor, age: age, level: level, tile_offset: tile_offset }
    end

    def inspect
        serialize.to_s
    end

    def to_s
        serialize.to_s
    end
end