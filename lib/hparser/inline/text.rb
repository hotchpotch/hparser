# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby
require 'hparser/inline/collectable'

module HParser
  module Inline
    class Text
      include Collectable
      attr_reader :text

      def self.<=>(o)
        1
      end

      def self.parse(scanner)
        if scanner.scan(%r!<a.*</a>!) or scanner.scan(/./m)
          Text.new(scanner.matched)
        end
      end
      
      def initialize(text)
        @text = text
      end
        
      def +(other)
        Text.new(self.text+other.text)
      end
      
      def ==(o)
        o.class == self.class and @text == o.text
      end
    end
  end
end
