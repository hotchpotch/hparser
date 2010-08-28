# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby
module HParser
  module Util
    # StringScanner like class
    class LineScanner
      attr_reader :matched, :matched_pattern
      def initialize(lines)
        @lines = lines
      end
      
      def scan(exp)
        @matched_pattern = nil
        if match?(exp) then
          @matched = @lines.shift
        else
          nil
        end
      end
      
      def skip(exp)
        if match?(exp) then
          @lines.shift
        else
          nil
        end
      end
      
      def match?(exp)
        if @lines == [] then
          false
        elsif exp.class == Regexp and (@matched_pattern = @lines[0].match(exp)) then
          true
        elsif @lines[0] == exp
          true
        else
          false
        end        
      end
    end
  end
end

