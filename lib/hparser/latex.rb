# Author:: Masayoshi Tajahashi (takahashimm@gmail.com)
# Copyright:: Copyright (c) 2010 Masayoshi Takahashi
# License::   Distributes under the same terms as Ruby
# This file define +to_latex+. +to_latex+ is convert hatena format to LaTeX.
#

module HParser
  # This module provide +to_latex+ method.
  # This method is intended to convert hatena format to LaTeX format.
  #
  # For example:
  #  Hatena::Parser.parse('*foo').to_latex # -> \section{foo}
  #  Hatena::Parser.parse('>|bar|<').to_latex # -> \begin{verbatim} <\n> bar <\n> \end{verbatim}
  #
  # Unlike html, LaTeX phrase cannot be separated with tag and conent.
  # so common methods, such like tag_name and html_content, are not always used.
  # Only to_latex method is commonly impletemted.
  # If content is +Arary+,each elements convert to LaTeX by
  # +to_latex+. Otherwise,using as it self.
  #
  module Latex
    def to_latex
      content = latex_content
      if content.class == Array then
        content = content.map{|x| x.to_latex}.join
      end
      content
    end
  end

  module Block
    class Head
      include Latex

      def to_latex
        content = super
        headers = [
                   nil,
                   "section",
                   "subsection",
                   "subsubsection",
                   "paragraph",
                   "subparagraph",
                   "textbf"
                  ]
        level = @@head_level + self.level - 1
        "\\#{headers[level]}{#{content}}\n\n"
      end

      @@head_level = 1
      def self.head_level=(l)
        @@head_level = l
      end
      def self.head_level
        @@head_level
      end

      alias_method :latex_content,:content
    end

    class P
      include Latex

      def to_latex
        content = super
        content += "\n\n"
        content
      end

      alias_method :latex_content, :content
    end

    class Empty
      def to_latex() "\n\n" end
    end

    class Pre
      include Latex

      def to_latex
        content = super
        %Q[\\begin{verbatim}\n#{content}\n\\end{verbatim}\n]
      end

      alias_method :latex_content, :content
    end

    class SuperPre
      include Latex

      def to_latex
        content = latex_content  ## not 'super'
        %Q[\\begin{verbatim}\n#{content}\n\\end{verbatim}\n]
      end

      alias_method :latex_content,:content
    end

    class Quote
      include Latex

      def to_latex
        content = super
        %Q[\\begin{quotation}\n#{content}\n\\end{quotation}\n]
      end

      def latex_content
        @items
      end
    end

    class Table
      def to_latex
        row_size = self.row_size

        output  = "\\begin{table}\n"
        output << "  \\centering\n"
        output << "  \\begin{tabular}{ #{"l " * row_size }}\n"
        self.map_row do |row|
          output << "    #{row.map{|cell| cell.to_latex }.join(" & ")} \\\\\n"
        end
        output << "  \\end{tabular}\n"
        output << "\\end{table}\n"
        output
      end

      def row_size
        self.map_row do |tr|
          return tr.size
        end
      end
    end

    class Dl
      include Latex

      class Item
        def to_latex
          dt = self.title.map{|x| x.to_latex}.join
          dd = self.description.map{|x| x.to_latex}.join

          %Q(\\item[#{dt}] \\quad \\\\\n#{dd}\n)
        end
      end

      def to_latex
        content = super
        %Q[\\begin{description}\n#{content}\n\\end{description}\n]
      end

      def latex_content
        @items
      end
    end

    class TableHeader
      include Latex

      def to_latex
        content = super
        content
      end

      alias_method :latex_content,:content
    end

    class TableCell
      include Latex

      def to_latex
        content = super
        content
      end

      alias_method :latex_content,:content
    end

    class UnorderList
      include Latex

      def to_latex
        content = super
        %Q[\\begin{itemize}\n#{items.map{|i| i.to_latex }.join("\n")}\n\\end{itemize}\n]
      end
      alias_method :latex_content,:items
    end

    class OrderList
      include Latex

      def to_latex
        content = super
        %Q[\\begin{enumerate}\n#{items.map{|i| i.to_latex }.join("\n")}\n\\end{enumerate}\n]
      end

      alias_method :latex_content,:items
    end


    class ListItem
      include Latex

      def to_latex
        content = super
        "  \\item #{content}\n"
      end

      alias_method :latex_content,:content
    end

    class RAW
      def to_latex
        @content.map {|i| i.to_latex }.join
      end
    end

    class FoonoteList
      def to_latex
        ""
      end
    end
  end

  module Inline
    class Text
      def to_latex
        self.text
      end
    end

    class Url
      def to_latex
        "\\href{#{self.url}/}{#{self.url}}"
      end
    end

    class HatenaId
      def to_latex
        "\\href{http://d.hatena.ne.jp/#{self.name}/}{id:#{self.name}}"
      end
    end

    class Fotolife
      def to_latex
        alias_method :to_latex,:url
      end
    end

    class Footnote
      def to_latex
        %(\\footnote{#{self.text}})
      end
    end

    class Comment
      def to_latex
        ""
      end
    end
  end
end


