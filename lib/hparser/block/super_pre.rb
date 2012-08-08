require 'hparser/block/pair'
require 'hparser/block/collectable'
module HParser
  module Block
    # Super pre parser.
    class SuperPre < Pair
      include Collectable

      def self.parse scanner,context,inlines

        content = format = nil
        if scanner.scan(/^>\|([A-Za-z0-9]*)\|\s*?$/)
          lines = []
          format = scanner.matched_pattern[1]
          until scanner.scan(/^\|\|<\s*?$/) do
            str = scanner.scan(/.*/)
            break if !str
            lines << str
          end
          content = lines.join("\n")
        end

        if content then
          SuperPre.new content, format
        end
      end

      attr_reader :format
      def initialize(content, format = nil)
        super content
        @format = format
      end

      def self.<=>(o)
        -1
      end
    end
  end
end
