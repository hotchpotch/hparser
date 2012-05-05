
require 'hparser/block/collectable'
require 'hparser/block/pair'

module HParser
  module Block
    class RAW < Pair
      include Collectable

      def self.parse(scanner, inlines)
        if scanner.scan(/^></)
          content = scanner.matched
          until content.match(/><$/)
            str = scanner.scan(/.*/)
            if str.nil? then
              content << "<"
              break
            end
            content << "\n" << str
          end
          self.new inlines.parse(content[1..-2])
        end
      end

      def ==(o)
        self.class == o.class and self.content == o.content
      end

      def self.<=>(o)
        -1
      end
    end
  end
end
