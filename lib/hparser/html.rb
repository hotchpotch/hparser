# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby
# This file define +to_html+. +to_html+ is convert hatena format to html.
#

module HParser
  # This module provide +to_html+ method.
  # This method is intended to convert  hatena format to html format.
  #
  # For example:
  #  Hatena::Parser.parse('*foo').to_html # -> <h1>foo</h1>
  #  Hatena::Parser.parse('>|bar|<').to_html # -> <pre>bar</pre>
  #
  # A class including this module shold implement 2 methods,+html_tag+ and 
  # +html_content+. Obviously,+html_tag+ provid using html tag name. 
  # +html_content+ is provid that content.
  # If content is +Arary+,each elements convert to html by
  # +to_html+. Otherwise,using as it self.
  #
  # For example,Head implements is following:
  #  class Hatena::Block::Head
  #    include Hatena::Html
  #    def tag_name
  #      "h#{@level}"
  #    end
  #
  #    def content
  #      @inlines
  #    end
  #  end
  # 
  module Html
    def to_html
      content = html_content
      if content.class == Array then
        content = content.map{|x| x.to_html}.join
      end
      %(<#{html_tag}>#{content}</#{html_tag}>)
    end
  end

  module Block
    class Head
      include Html
      private
      def html_tag
        "h#{@@head_level + self.level - 1}"
      end

      @@head_level = 1
      def self.head_level=(l)
        @@head_level = l
      end
      def self.head_level
        @@head_level
      end

      alias_method :html_content,:content
    end

    class P
      include Html
      private
      def html_tag() 'p' end

      alias_method :html_content,:content
    end

    class Empty
      def to_html() '<p><br /></p>' end
    end

    class Pre
      include Html
      private
      def html_tag() 'pre' end
      alias_method :html_content,:content
    end

    class SuperPre
      include Html
      def to_html
        content = html_content.gsub(/&/, "&amp;").gsub(/\"/, "&quot;").gsub(/>/, "&gt;").gsub(/</, "&lt;")
        %(<#{html_tag}>#{content}</#{html_tag}>)
      end
      def html_tag() 'pre' end
      alias_method :html_content,:content
    end

    class Quote
      include Html
      private
      def html_tag() 'blockquote' end
      alias_method :html_content,:content
    end

    class Table
      def to_html
        '<table>'+self.map_row{|tr|
          '<tr>'+tr.map{|cell| cell.to_html }.join + '</tr>'
        }.join+'</table>'
      end
    end

    class Dl
      include Html

      class Item
        def to_html
          dt = self.title.map{|x| x.to_html}.join
          dd = self.description.map{|x| x.to_html}.join
          "<dt>#{dt}</dt><dd>#{dd}</dd>"
        end
      end

      def html_tag() 
        'dl' 
      end

      def html_content
        @items
      end
    end

    class TableHeader
      include Html
      private
      def html_tag() 'th' end
      alias_method :html_content,:content
    end

    class TableCell
      include Html
      private
      alias_method :html_content,:content
      def html_tag() 'td' end
    end

    class UnorderList
      include Html
      private
      def html_tag
        'ul'
      end
      alias_method :html_content,:items
    end

    class OrderList
      include Html
      private
      def html_tag
        'ol'
      end
      alias_method :html_content,:items
    end


    class ListItem
      include Html
      private
      def html_tag
        'li'
      end
      alias_method :html_content,:content
    end

    class RAW
      def to_html
        @content.map {|i| i.to_html }.join
      end
    end
  end

  module Inline
    class Text
      def to_html
        self.text
      end
    end

    class Url
      def to_html
        %(<a href="#{self.url}">#{self.url}</a>)
      end
    end

    class HatenaId
      def to_html
        %(<a href="http://d.hatena.ne.jp/#{self.name}/">id:#{self.name}</a>)
      end
    end

    class Comment
      def to_html
        ""
      end
    end
  end
end
