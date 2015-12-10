# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby
# This file define +to_html+. +to_html+ is convert hatena format to html.
#

require 'cgi'

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

    def escape(str)
      CGI.escapeHTML(str)
    end
  end

  module ListContainerHtml
    def to_html
      f = false
      content = html_content.map{|x|
        if x.class == Block::ListItem
          s = (f ? "</li>" : "") + %(<li>#{x.to_html})
          f = true
          s
        else
          x.to_html
        end
      }.join
      content += "</li>" if f
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
      def to_html() '<br />' end
    end

    class SeeMore
      def to_html()
        if self.is_super
          '<a name="seeall"></a>'
        else
          '<a name="seemore"></a>'
        end
      end
    end

    class Pre
      include Html
      private
      def html_tag() 'pre' end
      alias_method :html_content,:content
    end

    class SuperPre
      include Html
      @@class_format_prefix = nil
      def self.class_format_prefix
        @@class_format_prefix
      end
      def self.class_format_prefix=(prefix)
        @@class_format_prefix = prefix
      end
      @@use_pygments = false
      def self.use_pygments
        @@use_pygments
      end
      def self.use_pygments=(use_or_not)
        @@use_pygments = use_or_not
      end

      def to_html
        content = html_content.gsub(/&/, "&amp;").gsub(/\"/, "&quot;").gsub(/>/, "&gt;").gsub(/</, "&lt;")
        if format && @@use_pygments
          # quick hack language name converter (super pre -> pygments)
          lang = format
          case format
          when "cs"
            lang = "csharp"
          when "lisp"
            lang = "cl"
          when "patch"
            lang = "diff"
          when "vb"
            lang = "vbnet"
          end

          begin
            require 'pygments'
            Pygments.highlight(html_content,
                               :lexer => lang, :options => {:encoding => 'utf-8'})
          rescue LoadError
            require 'albino'
            Albino.new(html_content, lang).colorize
          end
        elsif format
          %(<#{html_tag} class="#{@@class_format_prefix}#{escape(format)}">#{content}</#{html_tag}>)
        else
          %(<#{html_tag}>#{content}</#{html_tag}>)
        end
      end

      def html_tag() 'pre' end
      alias_method :html_content,:content
    end

    class Quote
      include Html

      class QuoteUrl
        include Html
        def initialize(url)
          @url = url
        end
        private
        def html_tag() 'cite' end
        def html_content() @url.to_html end
      end

      private
      def html_tag() 'blockquote' end
      def html_content
        if @url
          @items + [QuoteUrl.new(@url)]
        else
          @items
        end
      end
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
      include ListContainerHtml
      private
      def html_tag
        'ul'
      end
      alias_method :html_content,:items
    end

    class OrderList
      include ListContainerHtml
      private
      def html_tag
        'ol'
      end
      alias_method :html_content,:items
    end


    class ListItem
      def to_html
        if content.class == Array then
          content.map{|x| x.to_html}.join
        else
          content
        end
      end
    end

    class RAW
      def to_html
        @content.map {|i| i.to_html }.join
      end
    end

    class FootnoteList
      def to_html
        %(<div class="footnote">#{self.html_content}</div>)
      end

      def html_content
        @footnotes.map {|f| 
          %(<p class="footnote"><a href="#fn#{f.index}" name="f#{f.index}">*#{f.index}</a>: #{f.text}</p>)
        }.join
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
      include Html
      def to_html
        if @bookmark then
            require 'uri'
            enc_url = URI.encode(url)
            bookmark = %( <a href="http://b.hatena.ne.jp/entry/#{enc_url}" class="http-bookmark">) + 
                       %(<img src="http://b.hatena.ne.jp/entry/image/#{enc_url}" alt="" class="http-bookmark"></a>)
        end
        %(<a href="#{self.url}">#{escape(self.title)}</a>#{bookmark})
      end
    end

    class HatenaId
      def to_html
        if self.is_detail
          %(<a href="http://d.hatena.ne.jp/#{self.name}/" class="hatena-id-icon">) +
          %(<img src="http://www.st-hatena.com/users/#{self.name[0..1]}/#{self.name}/profile_s.gif") +
          %( width="16" height="16" alt="id:#{self.name}" class="hatena-id-icon">id:#{self.name}</a>)
        else
          %(<a href="http://d.hatena.ne.jp/#{self.name}/">id:#{self.name}</a>)
        end
      end
    end

    class Fotolife
      def to_html
        %(<a href="#{self.url}"><img src="#{self.image_url}"></a>)
      end
    end

    class Footnote
      def to_html
        text = self.text.gsub(/<.*?>/, '')
        %(<span class="footnote"><a href="#f#{self.index}" title="#{text}" name="fn#{self.index}">*#{self.index}</a></span>)
      end
    end

    class Tex
      include Html
      def to_html
        url = "http://chart.apis.google.com/chart?cht=tx&chf=bg,s,00000000&chl=" + CGI.escape(self.text)
        %(<img src="#{url}" class="tex" alt="#{escape(self.text)}">)
      end
    end

    class Comment
      def to_html
        ""
      end
    end
  end
end
