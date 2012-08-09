# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby

require 'hparser/inline/collectable'
module HParser
  module Inline
    class Footnote
      include Collectable

      attr_reader :index, :text
      def initialize(index, text)
        @index = index
        @text = text
      end

      def self.parse(scanner, context)
        if scanner.scan(/\)\(\(.+?\)\)\(/) then
          # )((xxx))( -> ((xxx))
          Text.new scanner[0][1..-2]
        elsif scanner.scan(/\(\((.+?)\)\)/) then
          index = context.footnotes.length + 1
          f = Footnote.new index, scanner[0][2..-3]
          context.footnotes << f
          f
        end
      end

      def ==(o)
        self.class == o.class and @index == o.index and @text == o.text
      end
    end
  end
end
