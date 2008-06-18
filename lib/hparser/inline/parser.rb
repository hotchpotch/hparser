# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby

require 'strscan'
require 'hparser/inline/collectable'
require 'hparser/util/parser'
module HParser
  module Inline
    class Parser
      include Util
      def initialize(parsers=Parser.default_parser)
        @document =  Many1.new(Or.new(*parsers))
      end

      def parse str
        scanner = StringScanner.new str
        join_text @document.parse(scanner)
      end

      def self.default_parser
        parser = []
        ObjectSpace.each_object(Class){|klass|
          if klass.include?(HParser::Inline::Collectable) then
            parser.push klass
          end
        }
        parser.sort{|a,b|
          a <=> b or -(b <=> a).to_i
        }
      end

      private
      def join_text(nodes)
        if nodes.length == 1 then
          nodes
        else
          rest = join_text nodes[1..-1]
          if rest[0].class == Text and nodes[0].class == Text then
            rest[1..-1].unshift(nodes[0]+rest[0])
          else
            rest.unshift nodes[0]
          end
        end
      end
    end
  end
end
