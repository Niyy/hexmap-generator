# 1280x720
require 'app/hex-grid.rb'
require 'app/continent.rb'


$rng = Random.new
$grid = HexGrid.new
$continents

def tick args
    $grid.args = args   
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

    $grid.input
    $grid.draw
end
