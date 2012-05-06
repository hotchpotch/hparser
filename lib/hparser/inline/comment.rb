

require 'hparser/inline/collectable'

module HParser
  module Inline
    class Comment
      include Collectable

      attr_reader :content

      def self.parse(scanner)
        if scanner.scan(/<!--.+-->/m)
          self.new(scanner.matched[4..-4])
        end
      end

      def initialize(content)
        @content = content
      end

      def ==(o)
        o.class == self.class and @content == o.content
      end
    end
  end
end
