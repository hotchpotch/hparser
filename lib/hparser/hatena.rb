# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby

module HParser
  # This module provide +to_hatena+ method.
  # This method is intended to convert  hatena format node to hatena format.
  #
  # For example:
  #  Hatena::Parser.parse('*foo').to_html # -> *foo
  #  Hatena::Parser.parse('>|bar|<').to_html # -> >|bar|<
  #
  # Please see also HParser::Text
  module Hatena
    def to_hatena
      content = hatena_content
      if content.class == Array then
        content = content.map{|x| x.to_hatena}.join
      end
      if self.respond_to? :hatena_filter,true
        content = hatena_filter content
      end
      content+"\n"
    end
  end

  module Block
    class P
      include Hatena
      private
      alias_method :hatena_content,:content
    end

    class Empty
      def to_hatena
        ''
      end
    end

    class Head
      include Hatena
      private
      def hatena_content
        self.content
      end

      def hatena_filter content
        '*'*self.level + content 
      end
    end

    class Quote
      include Hatena
      alias_method :hatena_content,:content
      def hatena_filter c
        ">>\n"+c+"\n<<"
      end
    end

    class Pre
      include Hatena
      alias_method :hatena_content,:content
      def hatena_filter c
        ">|\n"+c+"\n|<"
      end
    end

    class SuperPre
      include Hatena
      alias_method :hatena_content,:content
      def hatena_filter c
        ">||\n"+c+"\n||<"
      end
    end

    class Table
      def to_hatena
        map_row{|row|
          '|'+ row.map{|cell| cell.to_hatena.chomp}.join('|')+'|'
        }.join("\n")+"\n"
      end
    end

    class TableHeader
      include Hatena
      alias_method :hatena_content,:content
      def hatena_filter c
        '*'+c
      end
    end

    class TableCell
      include Hatena
      alias_method :hatena_content,:content
    end

    class UnorderList
      def to_hatena(level=0,label=nil)
        @items.map{|li| li.to_hatena(level+1,'-').chomp}.join("\n")+"\n"
      end
    end

    class OrderList
      def to_hatena(level=0,label=nil)
        @items.map{|li| 
          li.to_hatena(level+1,'+').chomp
        }.join("\n")+"\n"
      end
    end

    class ListItem
      include Hatena
      alias_method :hatena_content,:content
      alias_method :_to_hatena_,:to_hatena
      def to_hatena(level,label)
        label*level + _to_hatena_
      end
    end
  end

  module Inline
    class Text
      alias_method :to_hatena,:text
    end

    class Url
      alias_method :to_hatena,:url
    end

    class HatenaId
      def to_hatena
        "id:#{self.name}"
      end
    end
  end
end
