require 'test_helper'
require 'hparser/block/all'
require 'hparser/inline/all'
require 'hparser/markdown'

class MarkdownTest < Test::Unit::TestCase
  include HParser::Block
  include HParser::Inline
  def setup
#    @parser = HParser::Parser.new
  end

  def assert_md expect,node,opt={}
    assert_equal expect,node.to_md(opt)
  end

  def test_head
    assert_equal Head.head_level, 1
    assert_md "# foo\n",Head.new(1,[Text.new('foo')])
    Head.head_level = 2
    assert_md "## foo\n",Head.new(1,[Text.new('foo')])
    Head.head_level = 4
    assert_md "#### foo\n",Head.new(1,[Text.new('foo')])
    Head.head_level = 1
  end

  def test_p
    assert_md "foobar\n",P.new([Text.new('foobar')])
    assert_md "\n",Empty.new
  end

  def test_pre
    assert_md "<pre>foobar</pre>\n",Pre.new([Text.new("foobar")])
    assert_md "    foo\n    bar\n",SuperPre.new("foo\nbar")
    assert_md "    foo\n    bar\n",SuperPre.new("foo\nbar", "ruby")
    assert_md "```ruby\nfoo\nbar\n```\n",SuperPre.new("foo\nbar", "ruby"),fenced_code_blocks: true

    default_map = SuperPre.format_map
    begin
      SuperPre.format_map = {"ruby" => "ruby!!"}
      assert_md "```ruby!!\nfoo\nbar\n```\n",SuperPre.new("foo\nbar", "ruby!!"),fenced_code_blocks: true
    ensure
      SuperPre.format_map = default_map
    end
  end

  def test_quote
    assert_md "> foobar\n",Quote.new([P.new([Text.new('foobar')])])
    assert_md "> foobar\n> \n> foobar\n",Quote.new([P.new([Text.new('foobar')]),
                                                    P.new([Text.new('foobar')])])
    assert_md "> > foobar\n> \n> foobar\n",Quote.new([Quote.new([P.new([Text.new('foobar')])]),
                                                      P.new([Text.new('foobar')])])
    assert_md "> foobar\n> \n> <cite>[TITLE](http://example.com)</cite>\n",
              Quote.new([P.new([Text.new('foobar')])], Url.new('http://example.com', 'TITLE'))
  end

  def test_list
    assert_md "* aaa\n* bbb\n",Ul.new(Li.new([Text.new('aaa')]),Li.new([Text.new('bbb')]))
    assert_md "1. aaa\n2. bbb\n",Ol.new(Li.new([Text.new('aaa')]),Li.new([Text.new('bbb')]))
    assert_md "1. aaa\n  * bbb\n  * ccc\n",
              Ol.new(Li.new([Text.new('aaa')]),
                     Ul.new(Li.new([Text.new('bbb')]),
                            Li.new([Text.new('ccc')])))
    assert_md "* aaa\n  1. bbb\n",Ul.new(Li.new([Text.new('aaa')]),
                                         Ol.new(Li.new([Text.new('bbb')])))
  end

  def test_dl
    first = Dl::Item.new([Text.new('foo')],[Text.new('foo is ...')])
    second = Dl::Item.new([Text.new('bar')],[Text.new('bar is ...')])
    dl = Dl.new(first,second)
    assert_md "foo\n: foo is ...\n\nbar\n: bar is ...", dl, definition_lists: true
    assert_md dl.to_html, dl
  end

  def test_table
    table = Table.new([Th.new([Text.new('foo')]),Th.new([Text.new('bar')])],
                      [Th.new([Text.new('baz')]),Th.new([Text.new('xyzzy')])])
    assert_md "foo | bar\n----|----\nbaz | xyzzy", table, tables: true
    assert_md table.to_html, table
  end

  def test_footnote_list
    footnote = FootnoteList.new([Footnote.new(1, 'text1'), Footnote.new(2, 'text2')])
    assert_md "[^1]: text1\n[^2]: text2", footnote, footnotes: true
    assert_md footnote.to_html, footnote
  end

  def th str
    Th.new [Text.new(str)]
  end

  def td str
    Td.new [Text.new(str)]
  end
end
