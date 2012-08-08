# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby
require 'hparser/inline/collectable'

module HParser
  module Inline
    # hatena id parser.
    #
    # For example:
    #  id:mzp
    class HatenaId
      include Collectable
      attr_reader :name, :is_detail
      def initialize(name, is_detail=false)
        @name = name
        @is_detail = is_detail
      end
      
      def self.parse(scanner, context=nil)
        if scanner.scan(/id:([A-Za-z][a-zA-Z0-9_\-]{2,31})(:detail)?/) then
          HatenaId.new scanner[1], !scanner[2].nil?
        end
      end
      
      def ==(o)
        self.class == o.class and @name == o.name and @is_detail == o.is_detail
      end
    end
  end
end
