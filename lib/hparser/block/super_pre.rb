require 'hparser/block/pair'
require 'hparser/block/collectable'
module HParser
  module Block
    # Super pre parser.
    class SuperPre < Pair
      include Collectable

      def self.parse scanner,inlines

        content = format = nil
        if scanner.scan(/^>\|([A-Za-z0-9]*)\|\s*?$/)
          content = ''
          format = $1
          until scanner.scan(/^\|\|<\s*?$/) do
            str = scanner.scan(/.*/)
            break if !str
            content += "\n"+ str
          end
          content.strip!
        end

        if content then
          SuperPre.new content.gsub(/&/, "&amp;").gsub(/\"/, "&quot;").gsub(/>/, "&gt;").gsub(/</, "&lt;"), format
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
