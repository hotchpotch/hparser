# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby

require 'hparser/block/collectable'
module HParser
  module Block
    # Header parser.
    #
    # Header is defiend as "a line which is start with '*'". 
    # And a number of '*' show that level.
    #
    # For example:
    #  * level1
    #  ** level2
    #  *** level3
    class Head
      include Collectable
      def self.parse(scanner,inlines)
        if scanner.scan(/\A\*/) then
          level = 0
          scanner.matched.each_byte{|c|
            if c.chr == '*' then
              level += 1
            else
              break
            end
          }
          Head.new level,inlines.parse(scanner.matched[level..-1].strip)
        end
      end
      
      attr_reader :level,:content
      def initialize(level,content)
        @level = level
        @content = content
      end
      
      def ==(o)
        o.class == self.class and o.level == self.level and
          o.content == self.content
      end
    end
  end
end
