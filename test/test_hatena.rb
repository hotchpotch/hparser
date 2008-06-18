require 'test/unit'
require 'hparser'
require 'hparser/hatena'

class HatenaTest < Test::Unit::TestCase
  include HParser::Block
  include HParser::Inline
  def setup
    @parser = HParser::Parser.new
  end

  def assert_hatena expect,node
    assert_equal expect+"\n",node.to_hatena
  end

  def test_head
    assert_hatena "*foo",Head.new(1,[Text.new('foo')])
  end

  def test_p
    assert_hatena "foobar",P.new([Text.new('foobar')])
  end

  def test_empty
    assert_equal "",Empty.new.to_hatena
  end

  def test_pre
    assert_hatena ">|\nfoobar\n|<",Pre.new([Text.new('foobar')])
    assert_hatena ">||\nfoobar\n||<",SuperPre.new('foobar')
    assert_hatena ">|\nfoobar\nbar\n|<",Pre.new([Text.new("foobar\nbar")])
  end

  def test_quote
    assert_hatena ">>\nfoobar\n<<",Quote.new([Text.new('foobar')])
  end

  def test_table
    assert_hatena "|*foo|*bar|\n|baz|xyzzy|",
                Table.new([th('foo'),th('bar')],
                          [td('baz') ,td('xyzzy')])
  end

  def test_list
    assert_hatena "-aaa\n-bbb",Ul.new(Li.new([Text.new('aaa')]),Li.new([Text.new('bbb')]))
    assert_hatena "+aaa\n+bbb",Ol.new(Li.new([Text.new('aaa')]),Li.new([Text.new('bbb')]))
    assert_hatena "+aaa\n--bbb",Ol.new(Li.new([Text.new('aaa')]),
                                       Ul.new(Li.new([Text.new('bbb')])))
    assert_hatena "-aaa\n--bbb",Ul.new(Li.new([Text.new('aaa')]),
                                       Ul.new(Li.new([Text.new('bbb')])))
  end

  def th str
    Th.new [Text.new(str)]
  end

  def td str
    Td.new [Text.new(str)]
  end
end
