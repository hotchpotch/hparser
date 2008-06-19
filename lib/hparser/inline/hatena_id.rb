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
      attr_reader :name
      def initialize(name)
        @name = name
      end
      
      def self.parse(scanner)
        if scanner.scan(/id:[A-Za-z][a-zA-Z0-9_\-]{2,31}/) then
          HatenaId.new scanner.matched[3..-1]
        end
      end
      
      def ==(o)
        self.class == o.class and @name == o.name
      end
    end
  end
end
