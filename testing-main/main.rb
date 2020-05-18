def tick args
    init if args.state.tick_count == 0
    args.state.pers_obj.setPerspective

    args.outputs.sprites << args.state.pers_obj
    args.outputs.labels << [args.state.pers_obj.x + args.state.pers_obj.w / 2,
                            args.state.pers_obj.y + args.state.pers_obj.h / 2, 
                            "#{args.state.pers_obj.w}/#{args.state.pers_obj.h}"]
end


def init
    $gtk.args.state.pers_obj ||= PerspectiveSprite.new(0, 0, 720, 720, 0, "sprites/square-blue.png")
end


class Sprite
    attr_accessor :x, :y, :w, :h, :path, :angle, :a, :r, :g, :b, :source_x,
                :source_y, :source_w, :source_h, :flip_horizontally,
                :flip_vertically, :angle_anchor_x, :angle_anchor_y, :tile_x,
                :tile_y, :tile_w, :tile_h

    def primitive_marker
        :sprite
    end
end
  
# Inherit from type
class PerspectiveSprite < Sprite
    attr_accessor :level, :original_w, :original_h

    # constructor
    def initialize x, y, w, h, i_level, i_sprite
        self.x = x
        self.y = y
        self.w = self.original_w = w
        self.h = self.original_h = h
        self.level = i_level
        self.path = i_sprite
    end


    def setPerspective
        self.w = self.original_w - (level * (0.5 * self.original_w))
        self.h = self.original_h - (level * (0.5 * self.original_h))
    end


    def serialize
        { }
    end


    def inspect
        serialize.to_s  
    end


    def to_s
        serialize.to_s  
    end

end