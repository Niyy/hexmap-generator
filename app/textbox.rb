class TextBox
    attr_accessor :value, :dimensions, :location, :selected
    attr_gtk

    def initialize i_args
        @args = i_args
        @location = [0, 0]
        @dimensions = [40, 25]
        @value = Array.new
        @string_value = ""
    end


    def draw
        #args.outputs.borders << [@location[0], @location[1], @dimensions[0], @dimensions[1]]
        @args.outputs.labels << [@location[0], @location[1] + 22 , @string_value]
    end


    def changeValue
        if @args.keyboard.key_down.raw_key > 47 && !@args.keyboard.key_down.raw_key < 58
            @value << @args.keyboard.key_down.char
        elsif @args.keyboard.key_down.backspace
            @value.pop
        end

        if @string_value.length < @value.length
            for i in (@string_value.length)...@value.length do
                @string_value += @value[i]
            end
        elsif @string_value.length > @value.length
            for i in @value.length..@string_value.length do
                @string_value = @string_value.chop
            end
        end
    end


    def endPosition
        return_location = @location + @dimensions
        return @location.x * value.length * 10
    end


    def serialize                                                                                                                                                                   
        { value: value, dimensions: dimensions, location: location, selected: selected }                                                                                              
    end                                                                                                                                                                             
                                                                                                                                                                                      
                                                                                                                       
    def inspect                                                                                                                                                                     
        serialize.to_s                                                                                                                                                                
    end                                                                                                                                                                             
                                                                                                                                                                                    
                                                                                                                                    
    def to_s                                                                                                                                                                        
        serialize.to_s                                                                                                                                                                
    end  
end