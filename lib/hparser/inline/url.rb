# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby

require 'hparser/inline/collectable'
module HParser
  module Inline
    class Url
      include Collectable
      attr_reader :url, :title
      def self.parse(scanner)
        if scanner.scan(%r!https?://[A-Za-z0-9~\/._\?\&=\-%#\+:;,\@\'\$\*\!]+!) then
          Url.new scanner.matched, scanner.matched
        elsif scanner.scan(%r!\[(https?://[A-Za-z0-9~\/._\?\&=\-%#\+:;,\@\'\$\*\!]+):title(?:=([^:]*))?\]!) then
          Url.new scanner[1], scanner[2] || ""
        end
      end
      
      def initialize(url, title=nil)
        @url = url
        @title = title.nil? ? url : title.empty? ? "(undefined)" : title
      end
      
      def ==(o)
        self.class and o.class and @url == o.url and @title == o.title
      end
    end
  end
end
