# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby

module HParser
  # This module provide +to_text+ method.
  # This method is intended to convert  hatena format to text.
  #
  # For example:
  #  Hatena::Parser.parse('*foo').to_html # -> foo
  #  Hatena::Parser.parse('>|bar|<').to_html # -> bar
  #
  # Please see also HParser::Hatena
  module Text
    def to_text
      content = text_content
      if content.class == Array then
        content = content.map{|x| x.to_text}.join
      end
      content
    end
  end

  module Block
    class Head
      include Text
      alias_method :text_content,:content
    end

    class P
      include Text
      alias_method :text_content,:content
    end

    class Empty
      include Text
      def to_text
        ""
      end
    end

    module Indent
      include Text
      def text_content
        self.content
      end
      alias_method :_to_text_,:to_text
      def to_text
        self._to_text_.split("\n").map{|line| '  '+line}.join("\n")
      end
    end

    class Pre
      include Indent
    end
    class SuperPre
      include Indent
    end
    class Quote
      include Indent
    end

    class Table
      def to_text
        map_row do |tr|
          '|'+tr.map{|cell| cell.to_text}.join('|')+'|'
        end.join("\n")
      end
    end

    class TableHeader
      include Text
      alias_method :text_content,:content
    end

    class TableCell
      include Text
      alias_method :text_content,:content
    end

    class UnorderList
      def to_text
        @items.map{|li| '-'+li.to_text}.join("\n")
      end
    end

    class Dl
      class Item
        def to_text
          dt = self.title.map{|x| x.to_html}.join
          dd = self.description.map{|x| x.to_html}.join.split("\n").map{|x|
            '  '+x
          }.join("\n")
          "#{dt}\n#{dd}"
        end
      end

      def to_text
        @items.map{|x| x.to_text}.join("\n")
      end
    end


    class OrderList
      def to_text
        i = 0
        @items.map{|li| 
          i += 1
          "#{i}." +li.to_text 
        }.join("\n")
      end
    end

    class ListItem
      include Text
      def text_content
        [HParser::Inline::Text.new(' '),self.content].flatten
      end
    end
  end

  module Inline
    class Text
      alias_method :to_text,:text
    end

    class Url
      alias_method :to_text,:url
    end

    class HatenaId
      def to_text
        "id:#{self.name}"
      end
    end
  end
end
