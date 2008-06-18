# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby

require 'hparser/inline/collectable'
module HParser
  module Inline
    class Url
      include Collectable
      attr_reader :url
      def self.parse(scanner)
        if scanner.scan(%r!https?://[A-Za-z0-9./]+!) then
          Url.new scanner.matched
        end
      end
      
      def initialize(url)
        @url = url
      end
      
      def ==(o)
        self.class and o.class and @url == o.url
      end
    end
  end
end
