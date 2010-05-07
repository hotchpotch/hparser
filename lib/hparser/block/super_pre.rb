require 'hparser/block/pair'
require 'hparser/block/collectable'
module HParser
  module Block
    # Super pre parser.
    class SuperPre < Pair
      include Collectable

      def self.parse scanner,inlines
        content = get scanner,'>||','||<'
        if content then
          SuperPre.new content.gsub(/&/, "&amp;").gsub(/\"/, "&quot;").gsub(/>/, "&gt;").gsub(/</, "&lt;")
        end
      end

      def self.<=>(o)
        -1
      end
    end
  end
end
