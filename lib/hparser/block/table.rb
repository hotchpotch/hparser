# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby

require 'hparser/block/collectable'
module HParser
  module Block
    # Table parser.
    class Table
      attr_reader :rows
      include Collectable
      def self.parse(scanner,inlines)
        rows = []
        while scanner.scan(/\A\|/)
          rows.push scanner.matched[1..-1].split('|').map{|label|
            if label[0].chr == '*' then
              Th.new inlines.parse(label[1..-1].strip)
            else
              Td.new inlines.parse(label.strip)
            end
          }
        end
        rows == [] ? nil : Table.new(*rows)
      end
      
      def initialize(*rows)
        @rows = rows
      end
      
      def ==(o)
        o.class == self.class and o.rows == self.rows
      end

      def map_row(&f) # :yield: tr
        @rows.map(&f)
      end

      def each_row(&f) # :yield: tr
        @row.each(&f)
      end
    end
    
    class TableHeader
      attr_reader :content
      def initialize(content)
        @content = content
      end
        
      def ==(o)
        o.class == self.class and o.content == self.content
      end
    end
    
    class TableCell
      attr_reader :content
      def initialize(content)
        @content = content
      end
      
      def ==(o)
        o.class == self.class and o.content == self.content
      end
    end
    
    unless defined?(Th)
      Th = TableHeader
      Td = TableCell
    end
  end
end

