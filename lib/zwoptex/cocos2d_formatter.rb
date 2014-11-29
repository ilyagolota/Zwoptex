require 'plist'

module Zwoptex

  class Cocos2dFormatter

    def initialize atlas, options
      @atlas = atlas
      @texture_filename = options[:texture_filename]
    end

    def format
      frames_config = {}
      @atlas.frames.each do |f|
        frames_config[f.name] = {
          'spriteSize' => format_point(f.color_width, f.color_height),
          'spriteOffset' => format_point((f.color_x + f.color_width * 0.5) - f.width * 0.5, f.height * 0.5 - (f.color_y + f.color_height * 0.5)),
          'spriteSourceSize' => format_point(f.width, f.height),
          'spriteSourceColorRect' => format_rect(f.color_x, f.color_y, f.color_width, f.color_height),
          'spriteTrimmed' => (f.color_width < f.width || f.color_height < f.height),
          'textureRect' => format_rect(f.x + f.color_x, f.y + f.color_y, f.color_width, f.color_height),
          'textureRotated' => false,
          'aliases' => []
        }
      end

      Plist::Emit.dump({
        'metadata' => {
          'version' => '2.0.0',
          'size' => format_point(@atlas.width, @atlas.height),
          'format' => 3,
          'name' => @texture_filename,
          'textureFileName' => @texture_filename
        },
        'frames' => frames_config
      })
    end

  protected

    def format_point x, y
      "{#{x},#{y}}"
    end

    def format_rect x, y, width, height
      "{{#{x},#{y}},{#{width},#{height}}}"
    end
  end

end
