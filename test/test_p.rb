require 'test_helper'
require 'hparser/parser'
require 'hparser/block/p'

class PTest < Test::Unit::TestCase
  include HParser::Block
  include HParser::Inline

  def setup
    @parser = HParser::Parser.new [Empty,P]
  end

  def parse str
    @parser.parse str
  end

  def test_normal
    assert_equal [p("aaa")], parse("aaa")
  end

  def test_has_blank
    assert_equal [p("aaa")], parse(<<-END)
aaa

    END
  end

  def test_multi_line
    assert_equal [p("aaa"), p("bbb")], parse(<<-END)
aaa
bbb
    END

    assert_equal [p("aaa"), p("bbb"), Empty.new, p("aaa"), p("bbb")], parse(<<-END)
aaa
bbb


aaa
bbb
    END

    assert_equal [p("aaa"),Empty.new, p('bbb')], parse(<<-END)
aaa


bbb

    END
  end

  def test_empty
    assert_equal [p("aaa"),Empty.new,p('bbb')],
                  parse(<<-END)
aaa


bbb
    END
  end

  def p str
    P.new([Text.new(str)])
  end
end
