# 1280x720
require 'app/hex-grid.rb'
require 'app/continent.rb'

$rng = Random.new
# $grid = HexGrid.new
# $continents = Array.new

def initialize_state
    $gtk.args.state.reset_label = []
    $gtk.args.state.global_consintration = 7
    $gtk.args.state.global_size = 100
    $gtk.args.state.grid = HexGrid.new
    $gtk.args.state.grid.args = $gtk.args
    $gtk.args.state.grid.setUpGrid
    $gtk.args.state.continents = Array.new
end

def tick args
    initialize_state if $gtk.args.state.tick_count == 1

    if(args.state.continents.empty?)
        for i in 1..5 do
            root_x = $rng.rand(52)
            root_y = $rng.rand(21)

            args.state.continents.push Continent.new(args.state.grid.grid_positions[[root_x, root_y]], $rng, 
                                                    args.state.grid.grid_positions, 100, 10)
            args.state.continents.last.createContinent
            args.state.continents.last.args = args
        end
    end


    if(!args.state.continents.empty?)
        args.state.continents.each do |continent|
            if(!continent&.created)
                continent.addLand args.state.grid.grid_positions
            end
        end
    end


    args.state.reset = [3, 693, 20, 25]
    args.state.reset_label = [25, 715, "Reset"]
    next_pos = 25 + ("Reset".length * 10)

    args.outputs.borders << args.state.reset
    args.outputs.labels << args.state.reset_label

    if args.inputs.mouse.click
        if args.inputs.mouse.click.point.inside_rect? args.state.reset
            #args.state.continents = nil
            #args.state.grid.clearGrid
        end
    end

    # next_pos = adjustable_integer args, "size", next_pos, args.state.global_size
    # next_pos = adjustable_integer args, "consintration", next_pos, args.state.global_consintration

    $grid.input
    $grid.draw
end


def adjustable_integer args, ui_name, position, changeable_variable
    box_one = [position, 693, 15, 25]
    box_two = [position + 45, 693, 15, 25]
    
    args.outputs.borders << [position, 693, 15, 25]
    args.outputs.labels << [position + 2, 715, "-"]

    args.outputs.borders << [position + 45, 693, 15, 25]
    args.outputs.labels << [position + 47, 715, "+"]

    args.outputs.labels << [position + 63, 715, ui_name]
    
    if args.inputs.mouse.click
        if (args.inputs.mouse.click.point.inside_rect? box_one)
            changeable_variable = changeable_variable + 1
        elsif (args.inputs.mouse.click.point.inside_rect? box_two)
            changeable_variable = changeable_variable - 1
        end
    end

    args.outputs.labels << [position + 15, 715, "#{changeable_variable}"]

    return position + 63 + (ui_name.length * 10)
end