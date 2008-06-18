require 'test_helper'
require 'hparser/inline/hatena_id'
require 'hparser/inline/parser'

class IdTest < Test::Unit::TestCase
  include HParser::Inline
  def setup
    @parser = Parser.new HatenaId
  end

  def parse str
    @parser.parse str
  end

  def test_id
    assert_equal [HatenaId.new("mzp")],parse("id:mzp")
  end

  def test_jp
#    assert_equal [HatenaId.new("mzp"),Text.new("は")],parse("id:mzpは")
  end
end
