# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby

require 'hparser/block/collectable'
module HParser
  module Block
    # SeeMore line parser.
    #
    # ==== or =====
    class SeeMore
      include Collectable
      def self.parse(scanner,context,inlines)
        if scanner.scan('=====')
          SeeMore.new true
        elsif scanner.scan('====') then
          SeeMore.new false
        end
      end

      attr_reader :is_super
      def initialize(is_super)
        @is_super = is_super
      end

      def ==(o)
        o.class == self.class and o.is_super == self.is_super
      end
    end
  end
end
