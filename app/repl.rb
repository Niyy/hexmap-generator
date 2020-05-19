# Remove the x from xrepl to run the code. Add the x back to ignore to code.
repl do
  $gtk.args.state.token_list[0] = (Token.new($gtk.args, $gtk.args.state.grid.grid_positions, 
    $gtk.args.state.continents[0].root_tile, [$gtk.args.state.continents[0].root_tile.sprite.x, 
    $gtk.args.state.continents[0].root_tile.y, 8, 8, "sprites/circle-black.png"], 0.2))
end