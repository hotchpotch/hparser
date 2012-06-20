require 'test_helper'
require 'hparser/block/all'
require 'hparser/inline/all'
require 'hparser/html'

class HtmlTest < Test::Unit::TestCase
  include HParser::Block
  include HParser::Inline
  def setup
#    @parser = HParser::Parser.new
  end

  def assert_html expect,node
    assert_equal expect,node.to_html
  end

  def test_blank
    parser = HParser::Parser.new
    assert_equal parser.parse(''), []
  end

  def test_head
    assert_equal Head.head_level, 1
    assert_html '<h1>foo</h1>',Head.new(1,[Text.new('foo')])
    Head.head_level = 2
    assert_html '<h2>foo</h2>',Head.new(1,[Text.new('foo')])
    Head.head_level = 4
    assert_html '<h4>foo</h4>',Head.new(1,[Text.new('foo')])
    Head.head_level = 1
  end

  def test_p
    assert_html '<p>foobar</p>',P.new([Text.new('foobar')])
    assert_html '<br />',Empty.new
    assert_html '<a name="seemore"></a>',SeeMore.new(false)
    assert_html '<a name="seeall"></a>',SeeMore.new(true)
  end

  def test_pre
    assert_html '<pre>foobar</pre>',Pre.new([Text.new('foobar')])
    assert_html '<pre>foobar</pre>',SuperPre.new('foobar')
    assert_html "<pre>aaa\n bbb\nccc</pre>",SuperPre.new("aaa\n bbb\nccc")
    spre = SuperPre.new('foobar', 'ruby<>')
    assert_html '<pre class="ruby&lt;&gt;">foobar</pre>', spre
    spre = SuperPre.new('foobar', 'ruby')
    assert_html '<pre class="ruby">foobar</pre>', spre
    SuperPre.class_format_prefix = 'brush: '
    assert_html '<pre class="brush: ruby">foobar</pre>', spre
  end

  def test_quote
    assert_html '<blockquote><p>foobar</p></blockquote>',Quote.new([P.new([Text.new('foobar')])])
    assert_html '<blockquote><p>foobar</p><cite><a href="http://example.com">http://example.com</a></cite></blockquote>',
                Quote.new([P.new([Text.new('foobar')])], Url.new('http://example.com'))
    assert_html '<blockquote><p>foobar</p><cite><a href="http://example.com">TITLE</a></cite></blockquote>',
                Quote.new([P.new([Text.new('foobar')])], Url.new('http://example.com', 'TITLE'))
  end

  def test_table
    assert_html '<table><tr><th>foo</th><th>bar</th></tr><tr><td>baz</td><td>xyzzy</td></tr></table>',
                Table.new([th('foo'),th('bar')],
                          [td('baz') ,td('xyzzy')])
  end

  def test_list
    assert_html '<ul><li>aaa</li><li>bbb</li></ul>',Ul.new(Li.new([Text.new('aaa')]),Li.new([Text.new('bbb')]))
    assert_html '<ol><li>aaa</li><li>bbb</li></ol>',Ol.new(Li.new([Text.new('aaa')]),Li.new([Text.new('bbb')]))
    assert_html '<ol><ul><li>aaa</li></ul><li>bbb</li></ol>',Ol.new(Ul.new(Li.new([Text.new('aaa')])),
                                                                    Li.new([Text.new('bbb')]))
  end

  def test_dl
    expect = '<dl><dt>foo</dt><dd>foo is ...</dd><dt>bar</dt><dd>bar is ...</dd></dl>'
    first = Dl::Item.new([Text.new('foo')],[Text.new('foo is ...')])
    second = Dl::Item.new([Text.new('bar')],[Text.new('bar is ...')])
    assert_html expect,Dl.new(first,second)
  end

  def test_footnote_list
    expect = '<div class="footnote">' + 
             '<p class="footnote"><a href="#fn1" name="f1">*1</a>: text1</p>' + 
             '<p class="footnote"><a href="#fn2" name="f2">*2</a>: text2</p>' + 
             '</div>'
    assert_html expect, FootnoteList.new([Footnote.new(1, 'text1'), Footnote.new(2, 'text2')])
  end

  def th str
    Th.new [Text.new(str)]
  end

  def td str
    Td.new [Text.new(str)]
  end
end
