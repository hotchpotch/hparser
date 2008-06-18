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
    assert_html '<h1>foo</h1>',Head.new(1,[Text.new('foo')])
  end

  def test_p
    assert_html '<p>foobar</p>',P.new([Text.new('foobar')])
    assert_html '<p><br /></p>',Empty.new
  end

  def test_pre
    assert_html '<pre>foobar</pre>',Pre.new([Text.new('foobar')])
    assert_html '<pre>foobar</pre>',SuperPre.new('foobar')
  end

  def test_quote
    assert_html '<blockquote>foobar</blockquote>',Quote.new([Text.new('foobar')])
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

  def th str
    Th.new [Text.new(str)]
  end

  def td str
    Td.new [Text.new(str)]
  end
end
