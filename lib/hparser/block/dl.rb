# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby

require 'hparser/block/collectable'
module HParser
  module Block
    class Dl
      include Collectable
      class Item
        attr_reader :title,:description
        def initialize(title,description)
          @title = title
          @description = description
        end

        def ==(o)
          self.class == o.class and 
            self.title == o.title and
            self.description == o.description
        end
      end

      def self.parse(scanner,inlines)
        items = []
        while scanner.scan(/\A:/)
          i = scanner.matched.index(':',1)
          title = inlines.parse scanner.matched[1...i]
          description = inlines.parse scanner.matched[i+1..-1]
          items.push Item.new(title,description)
        end
        items == [] ? nil : self.new(*items)
      end

      attr_reader :items
      def initialize(*items)
        @items = items
      end

      def ==(o)
        o.class == self.class and o.items == self.items
      end
    end
  end
end
