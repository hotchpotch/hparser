# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby
# This code should be rewrite.
# Ul and Ol is depend each other.

require 'hparser/block/collectable'
require 'hparser/util/parser'
module HParser
  module Block
    include HParser::Util
    def self.make_list_parser(level,mark,&proc)
      ProcParser.new{|scanner,inlines|
        if level == 3 then
          parser = Many1.new(Li.make_parser(level,mark))
        else
          parser = Many1.new(Or.new(UnorderList.make_parser(level+1),
                                    OrderList.make_parser(level+1),
                                    Li.make_parser(level,mark)))
        end
        list = parser.parse(scanner,inlines)
        
        if list then
          proc.call list
        end
      }
    end

    # This class undocumented.
    # Maybe rewrite in near future.
    class UnorderList
      include Collectable
      def self.parse(scanner,inlines)
        Ul.make_parser(1).parse(scanner,inlines)
      end
      
      def self.make_parser(level)
        Block.make_list_parser(level,'-'){|x| Ul.new(*x)}
      end
      
      attr_reader :items
      def initialize(*items)
        @items = items
      end
      
      def ==(o)
        o.class == self.class and o.items == self.items
      end
    end

    # This class undocumented.
    # Maybe rewrite in near future.    
    class OrderList
      include Collectable
      def self.parse(scanner,inlines)
        Ol.make_parser(1).parse(scanner,inlines)
      end
      
      def self.make_parser(level)
        Block.make_list_parser(level,'+'){|x| Ol.new(*x) }
      end
      
      attr_reader :items
      def initialize(*items)
        @items = items
      end
      
      def ==(o)
        o.class == self.class and o.items == self.items
      end
    end
    
    # This class undocumented.
    # Maybe rewrite in near future.
    class ListItem
      def self.make_parser(level,mark)
        include HParser::Util
        ProcParser.new{|scanner,inlines|
          if scanner.scan(/\A#{Regexp.quote mark*level}.*/) then
            ListItem.new inlines.parse(scanner.matched[level..-1].strip)
          end
        }
      end
      
      attr_reader :content
      def initialize(content)
        @content = content
      end
      
      def ==(o)
        o.class==self.class and o.content == self.content
      end
    end
    
    unless defined?(Ul)
      Ul = UnorderList
      Ol = OrderList
      Li = ListItem
    end
  end
end
