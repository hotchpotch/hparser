require 'test_helper'
require 'hparser/inline/parser'
require 'hparser/inline/tex'

class TexTest < Test::Unit::TestCase
  include HParser::Inline
  def setup
    @parser = Parser.new [Tex]
  end

  def parse str
    @parser.parse str
  end

  def test_new
    tex = Tex.new("e^{i\pi} = -1")
    assert_equal "e^{i\pi} = -1", tex.text
  end

  def test_parse
    assert_equal [Tex.new("e^{i\pi} = -1")],
                 parse("[tex:e^{i\pi} = -1]")
  end
end
