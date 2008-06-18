# Author:: MIZUNO Hiroki (hiroki1124@gmail.com)
# Copyright:: Copyright (c) 2006 MIZUNO Hiroki
# License::   Distributes under the same terms as Ruby

require 'hparser/block/collectable'
require 'hparser/block/pair'
module HParser
  module Block
    # Pre format.
    class Pre < Pair
      include Collectable
      spliter '>|','|<'
    end
  end
end
