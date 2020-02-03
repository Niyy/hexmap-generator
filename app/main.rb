$hex_outline = [0, 0, 32, 30, "sprites/hex_outline.png"]

#
def tick args
    args.grid.origin_center!
    gridSnap(args, $hex_outline)

    args.outputs.sprites << [0, 0, 32, 30, "sprites/hex_grass_plain.png"]
    args.outputs.sprites << $hex_outline
end


def gridSnap args, hex_outline
    if args.inputs.mouse.x % 8 == 0
        hex_outline.x = args.inputs.mouse.x + 2 - 16
    end
end