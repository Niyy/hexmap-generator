# 1280x720

class Tile
    attr_accessor :inputs, :tile_info, :outputs, :grid, :args, :neighbors
    @degrees_to_rads = Math::PI / 180
    @rads_to_degrees = 180 / Math::PI

    def giveNeighbor tile
        angle = findAngleFrom(tile)

        if(angle == 30)
            puts "Neighbor: ", angle
        else
            puts "Neighbor: ", angle % 90
        end
    end

    def findAngleFrom tile
        polar_cord = Math.atan2(sprite.y - position.y, sprite.x - position.x)
        return polar_cord * rads_to_degrees
    end

    def draw
        outputs.sprites << tile_info
    end
end


$hex_outline = [0, 0, 32, 32, "sprites/hex_outline.png"]
$degrees_to_rads = Math::PI / 180
$rads_to_degrees = 180 / Math::PI


# def distance current, destination
#     x_squared = (destination.x - current.x) ** 2
#     y_squared = (destination.y - current.y) ** 2

#     return Math.sqrt(x_squared + y_squared)
# end

# $tile = Tile.new
# def tick args
#     $tile.outputs = args.outputs
#     args.grid.origin_center!
#     #gridSnap(args, $hex_outline)
    
#     for i in 0..5 do
#         radians = (30 + (60 * i)) * $degrees_to_rads
#         cos = Math.cos(radians)
#         sin = Math.sin(radians)
#         sprite_info = [cos * 31, sin * 31, 32, 32, "sprites/hex_grass.png"]

#         if sin < 0
#             sprite_info.y += 0.5
#         elsif sin > 0
#             sprite_info.y -= 0.9
#         end

#         if cos < 0.1
#             sprite_info.x += 0.9
#         elsif cos > 0.1
#             sprite_info.x -= 0.5
#         end
        
#         args.outputs.sprites << sprite_info
#     end

#     $tile.tile_info = [0, 0, 32, 32, "sprites/hex_grass.png"]
#     $tile.draw
#     #args.outputs.sprites << $hex_outline
# end