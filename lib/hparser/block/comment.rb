
require 'hparser/block/collectable'
require 'hparser/block/pair'

module HParser
  module Block
    class Comment < Pair
      include Collectable

      spliter('><!--', '--><')
      def self.parse scanner,inlines
        content = get scanner,'><!--','--><'
        if content then
          self.new content
        end
      end

      def self.<=>(o)
        -1
      end
    end
  end
end
