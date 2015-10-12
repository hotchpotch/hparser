# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby

module HParser
  # This module provide +to_text+ method.
  # This method is intended to convert  hatena format to text.
  #
  # For example:
  #  Hatena::Parser.parse('*foo').to_md # -> # foo
  #  Hatena::Parser.parse('>|bar|<').to_md # ->     bar
  #
  # Please see also HParser::Hatena
  module Markdown
    def to_md(opt={})
      content = md_content
      if content.class == Array then
        content = content.map{|x| x.to_md(opt)}.join
      end
      content
    end
    def indent(content, prefix)
        prefix + content.split("\n").join("\n" + prefix)
    end
  end

  module Block
    class Head
      include Markdown
      def to_md(opt={})
        '#' * (@@head_level + self.level - 1) + ' ' + super + "\n"
      end

      @@head_level = 1
      def self.head_level=(l)
        @@head_level = l
      end
      def self.head_level
        @@head_level
      end

      alias_method :md_content,:content
    end

    class P
      include Markdown

      def to_md(opt={})
        super + "\n"
      end

      alias_method :md_content, :content
    end

    class Empty
      def to_md(opt={})
        "\n"
      end
    end

    class SeeMore
      def to_md(opt={})
        ""
      end
    end

    class Pre
      def to_md(opt={})
        to_html + "\n"
      end
    end

    class SuperPre
      include Markdown

      def to_md(opt={})
        if opt.fetch(:fenced_code_blocks, false) && format
          "```#{mapped_format}\n#{md_content}\n```\n"
        else
          indent(md_content, '    ') + "\n"
        end
      end

      alias_method :md_content,:content
    end

    class Quote
      include Markdown

      class QuoteUrl
        def to_md(opt={})
          to_html
        end
      end

      def md_content
        if @url
          @items + [QuoteUrl.new(@url)]
        else
          @items
        end
      end

      def to_md(opt={})
        content = md_content.map{|x| x.to_md(opt)}.join("\n")
        indent(content, '> ') + "\n"
      end
    end

    class Table
      def to_md(opt={})
        if opt.fetch(:tables, false) && rows.size >= 2
          h = rows[0].map{|cell| cell.to_md(opt)}.join(' | ')
          s = rows[0].map{|cell| '----'}.join('|')
          b = rows[1..-1].map{|row|
            row.map{|cell| cell.to_md(opt)}.join(' | ')
          }.join("\n")
          [h, s, b].join("\n")
        else
          to_html
        end
      end
    end

    class TableHeader
      include Markdown
      alias_method :md_content,:content
    end

    class TableCell
      include Markdown
      alias_method :md_content,:content
    end

    class UnorderList
      include Markdown
      def to_md(opt={})
        @items.map{|li|
          if li.class == ListItem
            '* '+li.to_md(opt)
          else
            indent(li.to_md(opt), "  ")
          end
        }.join("\n") + "\n"
      end
      alias_method :md_content,:items
    end

    class Dl
      class Item
        def to_md(opt={})
          dt = self.title.map{|x| x.to_md(opt)}.join
          dd = self.description.map{|x| x.to_md(opt)}.join
          "#{dt}\n: #{dd}"
        end
      end
      def to_md(opt={})
        if opt.fetch(:definition_lists, false)
          @items.map{|x| x.to_md(opt)}.join("\n\n")
        else
          to_html
        end
      end
    end

    class OrderList
      include Markdown
      def to_md(opt={})
        i = 0
        @items.map{|li| 
          if li.class == ListItem
            i += 1
            "#{i}. " +li.to_md(opt)
          else
            indent(li.to_md(opt), "  ")
          end
        }.join("\n") + "\n"
      end
      alias_method :md_content,:items
    end

    class ListItem
      include Markdown
      alias_method :md_content,:content
    end

    class RAW
      def to_md(opt={})
        @content.map {|i| i.to_md(opt) }.join + "\n"
      end
    end

    class FootnoteList
      def to_md(opt={})
        if opt.fetch(:footnotes, false)
          @footnotes.map {|f| 
            "[^#{f.index}]: #{f.text}"
          }.join("\n")
        else
          to_html
        end
      end
    end
  end

  module Inline
    class Text
      def to_md(opt={})
        self.text
          .gsub(/<code>(.+?)<\/code>/i, '`\1`')
          .gsub(/<em>(.+?)<\/em>/i, '*\1*')
          .gsub(/<strong>(.+?)<\/strong>/i, '**\1**')
      end
    end

    class Url
      def to_md(opt={})
        if @bookmark then
          to_html
        elsif self.title == self.url && opt.fetch(:autolink, false)
          self.url
        else
          "[#{self.title}](#{self.url})"
        end
      end
    end

    class HatenaId
      def to_md(opt={})
        to_html
      end
    end

    class Fotolife
      def to_md(opt={})
        to_html
      end
    end

    class Tex
      def to_md(opt={})
        to_html
      end
    end

    class Footnote
      def to_md(opt={})
        if opt.fetch(:footnotes, false)
          "[^#{self.index}]"
        else
          to_html
        end
      end
    end

    class Comment
      def to_md(opt={})
        ""
      end
    end
  end
end
