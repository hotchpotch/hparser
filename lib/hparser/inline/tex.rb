# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby

require 'hparser/inline/collectable'
module HParser
  module Inline
    class Tex
      include Collectable

      attr_reader :text
      def initialize(text)
        @text = text
      end

      def self.parse(scanner, context=nil)
        if scanner.scan(/\[tex:([^\]]+)\]/) then
          Tex.new scanner[1]
        end
      end

      def ==(o)
        self.class == o.class and @text == o.text
      end
    end
  end
end
