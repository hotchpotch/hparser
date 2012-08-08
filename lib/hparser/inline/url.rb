# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby

require 'hparser/inline/collectable'
module HParser
  module Inline
    class Url
      include Collectable
      @@url_re = %r!https?://[A-Za-z0-9~\/._\?\&=\-%#\+:;,\@\'\$\*\!]+!
      @@bracket_url_with_title_re = %r!\[(#{@@url_re}):title(?:=(.*?))?(:bookmark)?\]!
      @@bracket_url_re = %r!\[(#{@@url_re})\]!

      attr_reader :url, :title, :bookmark
      def self.parse(scanner, context=nil)
        if scanner.scan(@@url_re) then
          Url.new scanner.matched, scanner.matched
        elsif scanner.scan(@@bracket_url_with_title_re) then
          title = ""
          title = scanner[2] if scanner[2] and scanner[2] != ":bookmark"
          bookmark = (scanner[2] == ":bookmark" || scanner[3] == ":bookmark")
          Url.new scanner[1], title, bookmark
        elsif scanner.scan(@@bracket_url_re)
          Url.new scanner[1]
        end
      end
      
      def initialize(url, title=nil, bookmark=false)
        @url = url
        @title = title.nil? ? url : title.empty? ? "(undefined)" : title
        @bookmark = bookmark
      end
      
      def ==(o)
        o and self.class and o.class and @url == o.url and @title == o.title and
          @bookmark == o.bookmark
      end
    end
  end
end
