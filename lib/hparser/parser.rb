# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby

require 'hparser/util/parser'
require 'hparser/inline/parser'
require 'hparser/block/collectable'
require 'hparser/util/line_scanner'

module HParser
  # Block level parser. +hparser+ split hatena format to 2 level.
  #
  # High-level is block elements. This can be identified by first char.
  #
  # For exapmle:
  #   * head1
  #   This is block element.(paragpaph)
  #   
  #   - list
  #   - is also
  #   -- block element
  #
  # Low-level is inline elements. Pleease see HParser::Inline::Parser.
  class Parser
    include HParser::Util
    include HParser::Block

    # Make parser with block parsers and inline parser.
    #
    # This parser can parse +blocks+, and parse block content
    # by +inlines+.
    #
    # If argument is not gived, this use default_parser.
    def initialize(blocks=HParser::Parser.default_parser,
                   inlines=HParser::Inline::Parser.new)
      @blocks = Many1.new(Concat.new(Or.new(*blocks),
                                     Skip.new(Empty)))
      @inlines = inlines
    end

    # Parse hatena format.
    #
    # Return array of block element.
    def parse str
      @blocks.parse(LineScanner.new(str.split("\n")),@inlines).map{|x|
        x[0]
      }
    end

    # Retutrn array of all usable parser.
    # 
    # This method collect all classes/modules which include
    # HParser::Block::Collectable. And sorting those by <=>. 
    def self.default_parser
      parser = []
      ObjectSpace.each_object(Class){|klass|
        if klass.include?(HParser::Block::Collectable) then
          parser.push klass
        end
      }

      # sorting parser.
      # e.g. Parser P should be after any other parser.
      parser.sort{|a,b|
        a <=> b or -(b <=> a).to_i
      }
    end
  end
end

