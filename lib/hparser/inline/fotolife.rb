# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby

require 'hparser/inline/collectable'
module HParser
  module Inline
    class Fotolife
      include Collectable

      attr_reader :id, :date, :time, :ext
      def initialize(id, date, time, ext)
        @id = id
        @date = date
        @time = time
        @ext = ext
      end

      def url
        "http://f.hatena.ne.jp/#{@id}/#{@date}#{@time}"
      end

      def image_url
        "http://f.hatena.ne.jp/images/fotolife/#{id[0]}/#{id}/#{@date}/#{@date}#{@time}.#{@ext}"
      end

      def self.parse(scanner)
        if scanner.scan(/\[f:id:([^:]+):(\d{8})(\d{6})(p|g|j):image(:[^\]]+)?\]/) then
          Fotolife.new scanner[1], scanner[2], scanner[3], 
                       scanner[4] == 'j' ? 'jpg' : scanner[4] == 'p' ? 'png' : 'gif'
        end
      end

      def ==(o)
        self.class == o.class and @id == o.id and @date == o.date and 
          @time == o.time and @ext == o.ext
      end
    end
  end
end
