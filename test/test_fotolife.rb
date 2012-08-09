require 'test_helper'
require 'hparser/inline/parser'
require 'hparser/inline/fotolife'

class FotolifeTest < Test::Unit::TestCase
  include HParser::Inline
  def setup
    @parser = Parser.new [Fotolife]
  end

  def parse str
    @parser.parse str
  end

  def test_new
    f = Fotolife.new("nitoyon", "20100718", "010346", "jpg")
    assert_equal "nitoyon", f.id
    assert_equal "20100718", f.date
    assert_equal "010346", f.time
    assert_equal "jpg", f.ext
    assert_equal "http://f.hatena.ne.jp/nitoyon/20100718010346", f.url
    assert_equal "http://f.hatena.ne.jp/images/fotolife/n/nitoyon/20100718/20100718010346.jpg", f.image_url
  end

  def test_parse
    assert_equal [Fotolife.new("nitoyon", "20100718", "010346", "jpg")],
                 parse("[f:id:nitoyon:20100718010346j:image]")
  end
end
