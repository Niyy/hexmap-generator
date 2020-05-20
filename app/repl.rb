

# Remove the x from xrepl to run the code. Add the x back to ignore to code.
xrepl do
  #$gtk.args.state.token = 
  $gtk.args.state.new_tile = Tile.new([1,1], [400, 200, 98, 98, "sprites/circle-green.png"], [400, 200, 98, 98, "sprites/circle-green.png"])
end

xrepl do 
  $gtk.args.outputs.sprites << $gtk.args.state.new_tile.sprite
end

xrepl do
  $gtk.args.state.token = (Token.new($gtk.args, $gtk.args.state.grid.grid_positions, 
    $gtk.args.state.new_tile.sprite, [100, 100, 8, 8, "sprites/circle-black.png"], 0.2))
end

xrepl do
  #puts $gtk.args.state.continents
  #puts $gtk.args.state.reset_label
  puts $gtk.args.state.grid
end

xrepl do
  puts_state $gtk.args.state

end