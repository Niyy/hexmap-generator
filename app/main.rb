# 1280x720
require 'app/hex-grid.rb'
require 'app/continent.rb'

$rng = Random.new
$grid = HexGrid.new
$continents
$size = 0

def tick args
    $grid.args ||= args   
    $grid.setUpGrid

    if($continents.nil?)
        $continents ||= Array.new()

        for i in 1..5 do
            root_x = $rng.rand(52)
            root_y = $rng.rand(21)

            $continents.push Continent.new($grid.grid_positions[[root_x, root_y]], $rng, $grid.grid_positions)
            $continents.last.createContinent
        end
    end

    for i in 0..4 do
        if(!$continents[i].created)
            $continents[i].addLand $grid.grid_positions
        end
    end

    

    # args.state.minus_box = [3, 693, 15, 25]
    # args.state.minus_lable = [5, 715, "-"]

    # args.state.plus_box = [45, 693, 15, 25]
    # args.state.plus_label = [47, 715, "+"]
    
    # if args.inputs.mouse.click
    #     if (args.inputs.mouse.click.point.inside_rect? args.state.plus_box)
    #         $size += 1
    #     elsif (args.inputs.mouse.click.point.inside_rect? args.state.minus_box)
    #         $size -= 1
    #     end
    # end

    # args.state.size_label = [27, 715, "#{$size}"]

    # args.outputs.borders << args.state.minus_box
    # args.outputs.borders << args.state.plus_box
    # args.outputs.labels << args.state.minus_lable
    # args.outputs.labels << args.state.plus_label
    # args.outputs.labels << args.state.size_label

    args.state.reset = [3, 693, 20, 25]
    args.state.reset_label = [25, 715, "Reset"]

    args.outputs.borders << args.state.reset
    args.outputs.labels << args.state.reset_label

    $grid.input
    $grid.draw

    if args.inputs.mouse.click
        if args.inputs.mouse.click.point.inside_rect? args.state.reset
            $continents = nil
        end
    end
end