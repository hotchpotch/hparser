require 'test_helper'
require 'hparser/parser'
require 'hparser/block/p'
require 'hparser/inline/parser'
require 'hparser/inline/footnote'

class FootnoteTest < Test::Unit::TestCase
  include HParser::Inline
  def setup
    @parser = Parser.new [Footnote]
  end

  def parse str
    @parser.parse str, HParser::Context.new
  end

  def test_new
    footnote = Footnote.new(1, "text")
    assert_equal 1, footnote.index
    assert_equal "text", footnote.text
  end

  def test_parse
    assert_equal [Footnote.new(1, "text")], parse("((text))")
    assert_equal [Footnote.new(1, "text1"),Footnote.new(2, "text2")], parse("((text1))((text2))")
    assert_equal [Text.new("((text))")], parse(")((text))(")
  end

  def test_parse_footnote_list
    f1 = Footnote.new(1, "text1")
    f2 = Footnote.new(2, "text2")

    # [ P ([ Footnote(...), Foonote(...) ]),
    #   FoonoteList([ Footnote(...), Foonote(...) ])
    # ]
    elements = HParser::Parser.new.parse("((text1))((text2))")

    assert_equal 2, elements.length
    assert_equal HParser::Block::P.new([f1, f2]), elements[0]
    assert_equal HParser::Block::FootnoteList.new([f1, f2]), elements[1]
  end
end
