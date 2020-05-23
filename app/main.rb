# 1280x720
require 'app/hex-grid.rb'
require 'app/continent.rb'
require 'app/textbox.rb'
# require 'app/token.rb'

$rng = Random.new

def initialize_state
    $gtk.args.state.reset_label = []
    $gtk.args.state.global_consintration = 100
    $gtk.args.state.global_size = 100
    $gtk.args.state.sprawl_amount = 100
    $gtk.args.state.random_tick = false
    $gtk.args.state.sprawling_tick = false
    $gtk.args.state.continent_amount = 1
    $gtk.args.state.grid = HexGrid.new
    $gtk.args.state.grid.args = $gtk.args
    $gtk.args.state.grid.initial_sprite = "sprites/hex_water.png"
    $gtk.args.state.grid.setUpGrid
    $gtk.args.state.continents = Array.new
    $gtk.args.state.token_list = Hash.new
    $gtk.args.state.token_count = 0

    $gtk.args.state.random_count = -11
    $gtk.args.state.reset_count = -11
end

def tick args
    initialize_state if $gtk.args.state.tick_count == 0

    if(args.state.continents.empty?)
        for i in 0...args.state.continent_amount do
            root_x = $rng.rand(52)
            root_y = $rng.rand(21)

            args.state.continents.push Continent.new(args, args.state.grid.grid_positions[[root_x, root_y]], $rng, 
                                                    args.state.grid.grid_positions, args.state.global_size,
                                                    args.state.global_consintration, args.state.random_tick, 
                                                    args.state.sprawling_tick, args.state.sprawl_amount)
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


    next_pos = [3]
    next_pos = marked_ui_element args, "reset", next_pos[0], :friend_clear
    next_pos = marked_ui_element args, "randomness", next_pos[0], :mark_randomness, args.state.random_tick
    new_textbox = TextBox.new args, [next_pos[0], 693]
    new_textbox.draw
    next_pos = [new_textbox.endPosition[0] + 20]

    # next_pos = adjustable_integer args, "size", next_pos[0], args.state.global_size
    # args.state.global_size = next_pos[1]
    # next_pos = adjustable_integer args, "concentration", next_pos[0], args.state.global_consintration
    # args.state.global_consintration = next_pos[1]
    # next_pos = adjustable_integer args, "continent amount", next_pos[0], args.state.continent_amount
    # args.state.continent_amount = next_pos[1]


    args.state.grid.input
    args.state.grid.draw
    args.state.token_list.each_value { |value|
        value.internalMove
        args.outputs.sprites << value.sprite
    }
end


def adjustable_integer args, ui_name, position, changeable_variable
    box_one = [position, 693, 15, 25]
    box_two = [position + 45, 693, 15, 25]
    adder = 1
    
    args.outputs.borders << [position, 693, 15, 25]
    args.outputs.labels << [position + 2, 715, "-"]

    args.outputs.borders << [position + 45, 693, 15, 25]
    args.outputs.labels << [position + 47, 715, "+"]

    args.outputs.labels << [position + 63, 715, ui_name]

    if args.inputs.keyboard.z
        adder = 10
    end
    
    if args.inputs.mouse.click
        if (args.inputs.mouse.click.point.inside_rect? box_one)
            changeable_variable = changeable_variable - adder
        elsif (args.inputs.mouse.click.point.inside_rect? box_two)
            changeable_variable = changeable_variable + adder
        end
    end

    args.outputs.labels << [position + 15, 715, "#{changeable_variable}"]
    args.outputs.labels << [position + 73 + (ui_name.length * 10), 715, "|"]

    return [position + 100 + (ui_name.length * 10), changeable_variable]
end


# 
def marked_ui_element args, ui_name, position, called_functions, value = false,
    button = [position, 693, 20, 25]
    label = [position + 25, 715, "#{ui_name}"]

    if args.inputs.mouse.click
        if args.inputs.mouse.click.point.inside_rect? button
            count = args.state.tick_count
            method(called_functions).call
        end
    end

    if(count + 1 > args.state.tick_count || value)
        args.outputs.solids << button
    else
        args.outputs.borders << button
    end

    args.outputs.labels << label
    args.outputs.labels << [position + 30 + (ui_name.length * 10), 715, "|"]

    return [position + 55 + (ui_name.length * 10)]
end


def friend_clear
    $gtk.args.state.grid.clearGrid
    $gtk.args.state.continents.clear
    $gtk.args.state.token_list.clear
end


def mark_randomness
    $gtk.args.state.random_tick = !$gtk.args.state.random_tick
end


def mark_sprawling
    $gtk.args.state.sprawling_tick = !$gtk.args.state.sprawling_tick
end


# Amir Rajan added to help find circular
def puts_state state, objects_sceen = []
    $gtk.append_file 'trace_state.txt', "circular reference detected! #{state} \n" and return if objects_sceen.include? state 
    objects_sceen << state
    if state.respond_to? :as_hash
      state.as_hash.each do |k, v|
        $gtk.append_file 'trace_state.txt', "#{k}\n"
          puts_state v, objects_sceen 
      end
    elsif state.is_a? Hash
      state.each do |k, v|
        $gtk.append_file 'trace_state.txt', "#{k}\n"
          puts_state v, objects_sceen
      end
    elsif state.is_a? Array
      state.each_with_index do |v, i|
            $gtk.append_file 'trace_state.txt', "#{v}\n"
        puts_state v, objects_sceen
      end
    else
        $gtk.append_file 'trace_state.txt', "#{state}\n"
    end
end