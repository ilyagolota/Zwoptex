
module Zwoptex
  
  class AtlasFrame

    attr_reader :color_x
    attr_reader :color_y
    attr_reader :color_width
    attr_reader :color_height
    attr_reader :image
    attr_accessor :x
    attr_accessor :y
    attr_accessor :name

    def initialize name, image
      @name = name
      @x, @y = 0, 0
      @image = image
      init_color_rect
    end

    def width
      @image.width
    end

    def height
      @image.height
    end

    def inspect
      "#<Zwoptex::Frame:#{object_id.to_s(16)} x=#{@x} y=#{@y} width=#{width} height=#{height}>"
    end

  protected

    def init_color_rect
      image_transparent = true

      (0...@image.width).each do |x|
        column_transparent = (0...@image.height).all?{|y| @image.get_pixel(x, y) == 0 }
        unless column_transparent
          @color_x = x
          image_transparent = false
          break
        end
      end

      if image_transparent
        @color_x, @color_y = 0, 0
        @color_width, @color_height = 0, 0
      else
        (0...@image.width).reverse_each do |x|
          column_transparent = (0...@image.height).all?{|y| @image.get_pixel(x, y) == 0 }
          unless column_transparent
            @color_width = x - @color_x + 1
            break
          end
        end

        (0...@image.height).each do |y|
          row_transparent = (@color_x..(@color_x + @color_width)).all?{|x| @image.get_pixel(x, y) == 0 }
          unless row_transparent
            @color_y = y
            break
          end
        end

        (0...@image.height).reverse_each do |y|
          row_transparent = (@color_x..(@color_x + @color_width)).all?{|x| @image.get_pixel(x, y) == 0 }
          unless row_transparent
            @color_height = y - @color_y + 1
            break
          end
        end
      end
    end

  end

end
