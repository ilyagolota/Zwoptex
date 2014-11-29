
module Zwoptex

  class TreePacker

    Node = Struct.new :x, :y, :width, :height, :frame, :child1, :child2

    def initialize atlas, options
      @atlas = atlas
      @spacing = options[:spacing]
    end

    def pack!
      root = Node.new 0, 0, @atlas.width - @spacing, @atlas.height - @spacing

      frames = @atlas.frames.sort { |a, b| b.color_width + b.color_height <=> a.color_width + a.color_height }
      frames.each do |f|
        f.x, f.y = 0, 0
        unless f.color_width * f.color_height == 0
          node = insert root, f
          f.x, f.y = node.x - f.color_x, node.y - f.color_y unless node.nil?
        end
      end
    end

  protected

    def insert node, frame
      if !node.frame.nil?
        nil

      elsif !node.child1.nil? && !node.child1.nil?
        new_node = insert node.child1, frame
        return new_node unless new_node.nil?

        new_node = insert node.child2, frame
        return new_node unless new_node.nil?

      elsif node.width < frame.color_width || node.height < frame.color_height
        nil

      elsif node.width == frame.color_width && node.height == frame.color_height
        node.frame = frame
        node

      else
        dw = node.width - frame.color_width
        dh = node.height - frame.color_height
        if dw > dh
          node.child1 = Node.new node.x, node.y, frame.color_width, node.height
          node.child2 = Node.new node.x + node.child1.width + @spacing, node.y, node.width - node.child1.width - @spacing, node.height
        else
          node.child1 = Node.new node.x, node.y, node.width, frame.color_height
          node.child2 = Node.new node.x, node.y + node.child1.height + @spacing, node.width, node.height - node.child1.height - @spacing
        end

        insert node.child1, frame
      end
    end

  end

end
