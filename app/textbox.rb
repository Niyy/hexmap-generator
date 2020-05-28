class TextBox
    attr_accessor :value, :dimensions, :location, :selected, :char_length, :string_value, :cursor_location
    attr_gtk

    def initialize i_args, char_length
        @args = i_args
        @location = [0, 0]
        @char_length = char_length
        @dimensions = [7 + 10 * char_length, 25]
        @cursor_location = 4 
        @value = Array.new
        @string_value = ""
        @selected = false
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
        @args.outputs.labels << [@location[0] + (@cursor_location * 10) - 2, @location[1] + 24, "|"]
        @args.outputs.labels << [@location[0] + x_position + 4, @location[1] + 22 , 
                                @string_value[0, @char_length]]
    end


    def update 
        self.changeCursorPosition
        self.checkIfSelected
        self.changeValue
    end


    def changeValue
        if @selected
            if @args.keyboard.key_down.raw_key >= 48 &&
            @args.keyboard.key_down.raw_key <= 57
                @string_value += @args.keyboard.key_down.char
            end
            
            if @args.keyboard.key_down.backspace
                @string_value = @string_value.chop
            end
        end
    end


    def changeCursorPosition
        if @args.keyboard.key_down.left && @cursor_location != 0
            @cursor_location -= 1
        elsif @args.keyboard.key_down.right && @cursor_location != 4
            @cursor_location += 1
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
        return @location.x * value.length * 10
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