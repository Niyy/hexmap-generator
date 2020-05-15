# 1280x720
require 'app/hex-grid.rb'
require 'app/continent.rb'

$rng = Random.new
# $grid = HexGrid.new
# $continents = Array.new

def initialize_state
    $gtk.args.state.reset_label = []
    $gtk.args.state.global_consintration = 50
    $gtk.args.state.global_size = 100
    $gtk.args.state.continent_amount = 1
    $gtk.args.state.grid = HexGrid.new
    $gtk.args.state.grid.args = $gtk.args
    $gtk.args.state.grid.initial_sprite = "sprites/hex_water.png"
    $gtk.args.state.grid.setUpGrid
    $gtk.args.state.continents = Array.new
end

def tick args
    initialize_state if $gtk.args.state.tick_count == 0

    if(args.state.continents.empty?)
        puts "refresh"
        for i in 0...args.state.continent_amount do
            root_x = $rng.rand(52)
            root_y = $rng.rand(21)

            args.state.continents.push Continent.new(args.state.grid.grid_positions[[root_x, root_y]], $rng, 
                                                    args.state.grid.grid_positions, args.state.global_size, args.state.global_consintration)
            args.state.continents.last.createContinent
            args.state.continents.last.args = args
        end
    end


    if(!args.state.continents&.empty?)
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
            args.state.grid.clearGrid
            args.state.continents.clear
        end
    end

    next_pos = adjustable_integer args, "size", next_pos, args.state.global_size
    args.state.global_size = next_pos[1]
    next_pos = adjustable_integer args, "consintration", next_pos[0], args.state.global_consintration
    args.state.global_consintration = next_pos[1]
    next_pos = adjustable_integer args, "continent amount", next_pos[0], args.state.continent_amount
    args.state.continent_amount = next_pos[1]

    args.state.grid.input
    args.state.grid.draw
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
            changeable_variable = changeable_variable - 1
        elsif (args.inputs.mouse.click.point.inside_rect? box_two)
            changeable_variable = changeable_variable + 1
        end
    end

    args.outputs.labels << [position + 15, 715, "#{changeable_variable}"]

    return [position + 63 + (ui_name.length * 10), changeable_variable]
end