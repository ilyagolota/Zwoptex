require 'chunky_png'

module Zwoptex

  class Atlas

    attr_reader :frames
    attr_accessor :width
    attr_accessor :height

    def initialize width, height, hash
      @width, @height = width, height
      @frames = hash.map{|name, image| AtlasFrame.new name, image }
    end

    def pack_using_tree! options
      TreePacker.new(self, options).pack!
    end

    def format_cocos2d_plist options
      Cocos2dFormatter.new(self, options).format
    end

    def render_image
      @frames.inject(ChunkyPNG::Image.new(width, height)) do |image, frame|
        image.compose!(frame.image, frame.x, frame.y)
        image
      end
    end

  end

end
