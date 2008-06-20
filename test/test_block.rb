require 'test_helper'
require 'hparser/parser'
require 'hparser/block/list'

class BlockTest < Test::Unit::TestCase
  include HParser::Block
  include HParser::Inline

  def setup
    @parser = HParser::Parser.new
  end

  def parse str
    @parser.parse str
  end

  def test_extra_empty
    assert_equal [Ul.new(li('a')),P.new([Text.new('b')])],parse(<<-END)
-a

b
END

    assert_equal [Head.new(1,[Text.new('a')]),P.new([Text.new('b')])],parse(<<-END)
*a

b
END
  end

  def test_ul
    assert_equal [Ul.new(li('a'),li('b'),li('c'))],
                  parse(<<-END)
- a
- b
- c
    END

    assert_equal [Ul.new(li('a'),Ul.new(li('b')),li('c'))],
                  parse(<<-END)
- a
-- b
- c
    END
  end

  def test_ol
    assert_equal [Ol.new(li('a'),li('b'),li('c'))],
                  parse(<<-END)
+ a
+ b
+ c
    END

    assert_equal [Ol.new(li('a'),Ol.new(li('b')),li('c'))],
                  parse(<<-END)
+ a
++ b
+ c
    END
  end

  def test_spre
    assert_equal [SuperPre.new('a')],parse(<<-END)
>||
a
||<
END
    assert_equal [SuperPre.new('a')],parse(<<-END), 'with space'
>|| 
a
||< 
END

  end

  def test_list
    assert_equal [Ul.new(li('a'),Ol.new(li('b')),Ul.new(li('c')))],
                  parse(<<-END)
- a
++ b
-- c
    END
  end


  def test_comment
    assert_equal [Comment.new("aaa")], parse(<<-END.unindent)
    ><!--
    aaa
    --><
    END
  end

  def li str
    Li.new([Text.new(str)])
  end
end
