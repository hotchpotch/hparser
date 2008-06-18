require 'test_helper'
require 'hparser'
require 'hparser/text'

class TextTest < Test::Unit::TestCase
  include HParser::Block
  include HParser::Inline
  def setup
    @parser = HParser::Parser.new
  end

  def assert_text expect,node
    assert_equal expect,node.to_text
  end

  def test_head
    assert_text 'foo',Head.new(1,[Text.new('foo')])
  end

  def test_p
    assert_text 'foobar',P.new([Text.new('foobar')])
  end

  def test_empty
    assert_text "",Empty.new
  end

  def test_pre
    assert_text '  foobar',Pre.new([Text.new('foobar')])
    assert_text '  foobar',SuperPre.new('foobar')
    assert_text "  foobar\n  bar",Pre.new([Text.new("foobar\nbar")])
  end

  def test_quote
    assert_text '  foobar',Quote.new([Text.new('foobar')])
  end

  def test_dl
    expect = <<-END.chomp
foo
  foo is ...
bar
  bar is ...
END
    first = Dl::Item.new([Text.new('foo')],[Text.new('foo is ...')])
    second = Dl::Item.new([Text.new('bar')],[Text.new('bar is ...')])
    assert_text expect,Dl.new(first,second)
  end

  def test_table
    assert_text "|foo|bar|\n|baz|xyzzy|",
                Table.new([th('foo'),th('bar')],
                          [td('baz') ,td('xyzzy')])
  end

  def test_list
    assert_text "- aaa\n- bbb",Ul.new(Li.new([Text.new('aaa')]),Li.new([Text.new('bbb')]))
    assert_text "1. aaa\n2. bbb",Ol.new(Li.new([Text.new('aaa')]),Li.new([Text.new('bbb')]))
    assert_text "1.- aaa\n2. bbb",Ol.new(Ul.new(Li.new([Text.new('aaa')])),
                                           Li.new([Text.new('bbb')]))
    assert_text "-- aaa\n- bbb",Ul.new(Ul.new(Li.new([Text.new('aaa')])),
                                       Li.new([Text.new('bbb')]))
  end

  def th str
    Th.new [Text.new(str)]
  end

  def td str
    Td.new [Text.new(str)]
  end
end
