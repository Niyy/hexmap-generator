$hex_outline = [0, 0, 32, 32, "sprites/hex_outline.png"]
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
    mouse_holder = [args.inputs.mouse.x - 16, args.inputs.mouse.y - 16]
    polar_cord = Math.atan2(mouse_holder.y - $hex_outline[0], mouse_holder.x - $hex_outline[1])

    if distance(mouse_holder, $hex_outline) <= 30.0 && distance(mouse_holder, $hex_outline) >= 28.0
        $hex_outline[0] = $hex_outline[0] + (Math.cos(polar_cord) * 30)
        $hex_outline[1] = $hex_outline[1] + (Math.sin(polar_cord) * 30)
    end

    puts distance mouse_holder, $hex_outline
end


def distance current, destination
    x_squared = (destination.x - current.x) ** 2
    y_squared = (destination.y - current.y) ** 2

    return Math.sqrt(x_squared + y_squared)
end