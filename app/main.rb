$hex_outline = [-16, -16, 32, 32, "sprites/hex_outline.png"]
$degrees_to_rads = Math::PI / 180


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
    if args.inputs.mouse.x % 16 <= 1
        hex_outline.x = args.inputs.mouse.x - 16
    end
    if args.inputs.mouse.y % 16 <= 1
        hex_outline.y = args.inputs.mouse.y - 16
    end
end


def distance args
end