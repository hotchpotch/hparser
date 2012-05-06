require 'strscan'
require 'hparser/block/pair'
require 'hparser/block/collectable'
require 'hparser/inline/url'
module HParser
  module Block
    # Quote parser.
    class Quote
      include Collectable
      include HParser::Inline
      include HParser::Util
      @@start_pattern = /^>(.*)>\s*$/
      @@end_pattern = /^<<\s*$/
      @@blocks = Concat.new(Or.new(*HParser::Parser.default_parser),
                            Skip.new(Empty))

      def self.parse(scanner,inlines)
        if scanner.scan(@@start_pattern)
          url = Url.parse(StringScanner.new "[#{scanner.matched_pattern[1]}]")

          items = []
          until scanner.scan(@@end_pattern)
            break unless scanner.match? /.*/
            items << @@blocks.parse(scanner,inlines)[0]
          end
          self.new(items, url)
        end
      end

      attr_reader :items, :url
      def initialize(items, url = nil)
        @items = items
        @url = url
      end

      def ==(o)
        o and self.class == o.class and self.items == o.items and @url == o.url
      end
    end
  end
end
