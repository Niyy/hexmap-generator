class TextBox
    attr_accessor :value, :dimensions, :location, :selected, :char_length, :string_value, :cursor_location,
        :cursor_to_numbers_location, :descriptor
    attr_gtk

    def initialize i_args, i_string_value, char_length, i_descriptor
        @args = i_args
        @location = [0, 0]
        @char_length = char_length
        @dimensions = [7 + 10 * char_length, 25]
        @cursor_location = 4 
        @cursor_to_numbers_location = 0
        @value = Array.new
        @string_value = ""
        @selected = false
        @descriptor = i_descriptor
        @string_value = i_string_value
    end


    def draw
        x_position = 40

        if(@string_value.length <= 4)
            x_position = (40 - (@string_value.length * 10))
        else
            x_position = 0
        end

        @args.outputs.borders << [@location[0], @location[1], @dimensions[0], @dimensions[1]]
        @args.outputs.solids << [@location[0], @location[1], @dimensions[0], @dimensions[1], 230, 230, 230]
        @args.outputs.labels << [@location[0] + x_position + 4, @location[1] + 22 , 
                                @string_value[0, @char_length]]
                
        if @selected
            @args.outputs.labels << [@location[0] + (@cursor_location * 10) - 2, @location[1] + 24, "|"]
        end

        if @descriptor.length > 0
            @args.outputs.labels << [@location[0] + 15 + (@descriptor.length * 10), @location[1] + 22, 
                @descriptor]
        end
    end


    def update 
        self.checkIfSelected

        if @selected
            self.changeCursorPosition
            self.changeValue
        end
    end


    def changeValue
        if @args.keyboard.key_down.raw_key >= 48 &&
        @args.keyboard.key_down.raw_key <= 57 && 
        @string_value.length < @char_length
            if @string_value.length == 0 || @cursor_to_numbers_location == 0
                @string_value += @args.keyboard.key_down.char
            else
                if @cursor_to_numbers_location == @string_value.length
                    @string_value = @args.keyboard.key_down.char + @string_value.slice(0..@cursor_to_numbers_location)
                else
                    @string_value = @string_value.slice(0...(@string_value.length - @cursor_to_numbers_location)) +
                        @args.keyboard.key_down.char +
                        @string_value.slice((@string_value.length - @cursor_to_numbers_location)...@string_value.length)
                end
            end
        end
        
        if @args.keyboard.key_down.backspace

            if @cursor_to_numbers_location == 0
                @string_value = @string_value.chop
            elsif @string_value.length > @cursor_to_numbers_location
                start = @string_value.slice(0...(@string_value.length - @cursor_to_numbers_location - 1))
                ending = @string_value.slice((@string_value.length - @cursor_to_numbers_location)..@string_value.length)

                if !ending.nil?
                    @string_value = start + ending
                end
            end
        end

        if @args.keyboard.key_down.return
            @selected = false;
        end

        if @args.keyboard.key_down.delete
            if @string_value.length >= @cursor_to_numbers_location
                start = @string_value.slice(0...(@string_value.length - @cursor_to_numbers_location))
                ending = @string_value.slice((@string_value.length - @cursor_to_numbers_location + 1)..@string_value.length)

                if !ending.nil?
                    @string_value = start + ending
                end

                @cursor_to_numbers_location -= 1
                @cursor_location += 1
            end
        end
    end


    def changeCursorPosition
        if  @args.keyboard.key_down.left && @cursor_location != 0 &&
            @cursor_to_numbers_location < @string_value.length
            @cursor_location -= 1
            @cursor_to_numbers_location += 1
        elsif   @args.keyboard.key_down.right && @cursor_location != 4
            @cursor_location += 1
            @cursor_to_numbers_location -= 1
        end
    end


    def checkIfSelected
        if @args.mouse.click
            if @args.mouse.click.point.inside_rect? [@location[0], @location[1], @dimensions[0], @dimensions[1]]
                @selected = true
                puts "selected"
            else
                @selected = false
                puts "not selected"
            end
        end
    end


    def endPosition
        return_location = @location + @dimensions
        return [@return_location * value.length * 10]
    end


    def serialize                                                                                                                                                                   
        { value: value, dimensions: dimensions, location: location, selected: selected, 
            string_value: string_value, cursor_location: cursor_location }                                                                                              
    end                                                                                                                                                                             
                                                                                                                                                                                      
                                                                                                                       
    def inspect                                                                                                                                                                     
        serialize.to_s                                                                                                                                                                
    end                                                                                                                                                                             
                                                                                                                                                                                    
                                                                                                                                    
    def to_s                                                                                                                                                                        
        serialize.to_s                                                                                                                                                                
    end  
end