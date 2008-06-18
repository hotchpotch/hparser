# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby

require 'hparser/block/collectable'
module HParser
  module Block
    # Blank line parser. This parser should be use with HParser::Block::P.
    # 
    # This parser can parse blank line.
    #
    # For example:
    #  aaaa
    #  <blank>
    #  <blonk>
    #
    # First line and second line is parsed with HParser::Block::P. And
    # third line is parsed with HParser::Block::Empty.
    class Empty
      include Collectable
      def self.parse(scanner,inlines)
        if scanner.scan('') then
          Empty.new
        end
      end
      
      def ==(o)
        o.class == self.class
      end
    end
    
    # Normal line parser.
    #
    # At hatena format, a line which is not parsed by any other parser is
    # paragraph.
    class P
      include Collectable
      attr_reader :content
      def self.parse(scanner,inlines)
        if scanner.scan(/./) then
          P.new inlines.parse(scanner.matched)
        end
      end
      
      def initialize(content)
        @content = content
      end
      
      def ==(o)
        self.class == o.class and self.content == o.content
      end

      def self.<=>(o)
        # This parser should be last.
        o.class == P ? nil : 1
      end
    end
  end
end
