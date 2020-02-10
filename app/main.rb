$hex_outline = [-16, -16, 32, 32, "sprites/hex_outline.png"]
$degrees_to_rads = Math::PI / 180
$rads_to_degrees = 180 / Math::PI


def tick args
    args.grid.origin_center!
    gridSnap(args, $hex_outline)

    for i in 0..5 do
        radians = (30 + (60 * i)) * $degrees_to_rads
        args.outputs.sprites << [Math.cos(radians) * 30, Math.sin(radians) * 30, 32, 32, "sprites/hex_grass_plain.png"]
    end

    args.outputs.sprites << [0, 0, 32, 32, "sprites/hex_grass_plain.png"]
    args.outputs.sprites << $hex_outline
end


def gridSnap args, hex_outline
    polar_cord = Math.atan2(args.inputs.mouse.y - $hex_outline[0], args.inputs.mouse.x - $hex_outline[1])
    mouse_holder = 

    if(distance args.inputs.mouse, $hex_outline) == 16.0
        $hex_outline[0] = args.inputs.mouse.x - 16
        $hex_outline[1] = args.inputs.mouse.y - 16
    end

    puts distance args.inputs.mouse, $hex_outline
end


def distance current, destination
    x_squared = (destination.x - current.x) ** 2
    y_squared = (destination.y - current.y) ** 2

    return Math.sqrt(x_squared + y_squared)
end