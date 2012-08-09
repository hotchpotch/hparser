# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby

module HParser
  module Block
    class FootnoteList
      attr_reader :footnotes

      def initialize(footnotes)
        @footnotes = footnotes
      end

      def ==(o)
        self.class == o.class and self.footnotes == o.footnotes
      end
    end
  end
end
