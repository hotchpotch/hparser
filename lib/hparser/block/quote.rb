require 'hparser/block/pair'
require 'hparser/block/collectable'
module HParser
  module Block
    # Quote parser.
    class Quote < Pair
      include Collectable
      spliter '>>','<<'
    end
  end
end
