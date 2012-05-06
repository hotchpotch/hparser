require 'hparser/block/pair'
require 'hparser/block/collectable'
module HParser
  module Block
    # Quote parser.
    class Quote
      include Collectable
      include HParser::Util
      @start_pattern = /^>>\s*$/
      @end_pattern = /^<<\s*$/
      @blocks = Or.new(*HParser::Parser.default_parser)

      def self.parse(scanner,inlines)
        if scanner.scan(@start_pattern)
          items = []
          until scanner.scan(@end_pattern)
            break unless scanner.match? /.*/
            items << @blocks.parse(scanner,inlines)
          end
          self.new(*items)
        end
      end

      attr_reader :items
      def initialize(*items)
        @items = items
      end

      def ==(o)
        self.class == o.class and self.items == o.items
      end
    end
  end
end
