# 1280x720
require 'app/hex-grid.rb'
require 'app/continent.rb'

$rng = Random.new
$grid = HexGrid.new
$continents
$size = 100
$consintration = 7


def tick args
    $grid.args ||= args   
    $grid.setUpGrid

    if($continents.nil?)
        $continents ||= Array.new()

        for i in 1..5 do
            root_x = $rng.rand(52)
            root_y = $rng.rand(21)

            $continents.push Continent.new($grid.grid_positions[[root_x, root_y]], $rng, $grid.grid_positions,
                                            $size, $consintration)
            $continents.last.createContinent
        end
    end

    for i in 0..4 do
        if(!$continents[i].created)
            $continents[i].addLand $grid.grid_positions
        end
    end

    

    # args.state.minus_box = [80, 693, 15, 25]
    # args.state.minus_lable = [82, 715, "-"]

    # args.state.plus_box = [125, 693, 15, 25]
    # args.state.plus_label = [129, 715, "+"]
    
    # if args.inputs.mouse.click
    #     if (args.inputs.mouse.click.point.inside_rect? args.state.plus_box)
    #         $size += 1
    #     elsif (args.inputs.mouse.click.point.inside_rect? args.state.minus_box)
    #         $size -= 1
    #     end
    # end

    # args.state.size_label = [95, 715, "#{$size}"]
    adjustable_integer args, "size", 80, $size

    args.state.reset = [3, 693, 20, 25]
    args.state.reset_label = [25, 715, "Reset"]

    args.outputs.borders << args.state.reset
    args.outputs.labels << args.state.reset_label

    $grid.input
    $grid.draw

    if args.inputs.mouse.click
        if args.inputs.mouse.click.point.inside_rect? args.state.reset
            $continents = nil
            $grid.clearGrid
        end
    end
end


def adjustable_integer args, ui_name, position, changeable_variable
    box_one = [position, 693, 15, 25]
    box_two = [position + 45, 693, 15, 25]
    
    args.outputs.borders << [position, 693, 15, 25]
    args.outputs.labels << [position + 2, 715, "-"]

    args.outputs.borders << [position + 45, 693, 15, 25]
    args.outputs.labels << [position + 47, 715, "+"]
    
    # if args.inputs.mouse.click
    #     if (args.inputs.mouse.click.point.inside_rect? box_holder["first-box"])
    #         changeable_variable += 1
    #     elsif (args.inputs.mouse.click.point.inside_rect? box_holder["second-box"])
    #         changeable_variable -= 1
    #     end
    # end

    args.outputs.labels << [position + 15, 715, "#{changeable_variable}"]
end