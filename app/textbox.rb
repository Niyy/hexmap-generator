class TextBox
    attr_accessor :value, :dimensions, :location, :selected
    attr_gtk

    def initialize i_args, i_location
        @args = i_args
        @location = i_location
        @dimensions = [40, 25]
        @value = Array.new
    end


    def draw
        #args.outputs.borders << [@location[0], @location[1], @dimensions[0], @dimensions[1]]
        if @args.keyboard.key_down.truthy_keys.length > 0
            @args.outputs.labels << [@location[0], @location[1] + 22 , @args.keyboard.key_down.char]
        end
    end


    def changeValue

    end


    def endPosition
        return @location + @dimensions
    end
end