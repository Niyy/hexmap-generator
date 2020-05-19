# Remove the x from xrepl to run the code. Add the x back to ignore to code.
xrepl do
  $gtk.args.state.tiles[0].neighbor["a"] ||= $gtk.args.state.tiles[1]
  $gtk.args.state.tiles[1].neighbor["a"] ||= $gtk.args.state.tiles[0]

end