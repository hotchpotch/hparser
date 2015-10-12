require 'test_helper'
require 'hparser/inline/all'
require 'hparser/parser'
require 'hparser/markdown'

class MarkdownInlineTest < Test::Unit::TestCase
  include HParser::Inline
  def setup
    @parser = Parser.new
  end

  def assert_md expect,str,opt={}
    expect.class == String and (expect = [expect])

    context = HParser::Context.new
    assert_equal expect,@parser.parse(str, context).map{|x| x.to_md(opt)}
  end

  def assert_same str
    assert_md [str],str
  end

  def test_url
    assert_md '[http://mzp.sakura.ne.jp](http://mzp.sakura.ne.jp)',
              'http://mzp.sakura.ne.jp'
    assert_md 'http://mzp.sakura.ne.jp',
              'http://mzp.sakura.ne.jp',
              autolink: true
    assert_md '[TITLE](http://example.com/)',
              '[http://example.com/:title=TITLE]'
    assert_md '[A&B](http://example.com/)',
              '[http://example.com/:title=A&B]'
    assert_md '<a href="http://example.com/#a">TITLE</a> ' + 
              '<a href="http://b.hatena.ne.jp/entry/http://example.com/%23a" class="http-bookmark">' + 
              '<img src="http://b.hatena.ne.jp/entry/image/http://example.com/%23a" alt="" class="http-bookmark"></a>',
              '[http://example.com/#a:title=TITLE:bookmark]'
  end

  def test_footnote
    assert_md '[^1]', '((aaa))', footnotes: true
    assert_md Footnote.new(1, 'aaa').to_html, '((aaa))'
  end

  def test_markdownify
    assert_md 'aa `b` cc `d`',
              'aa <code>b</code> cc <CODE>d</CODE>'
    assert_md 'aa *b* cc *d*',
              'aa <em>b</em> cc <EM>d</EM>'
    assert_md 'aa **b** cc **d**',
              'aa <strong>b</strong> cc <STRONG>d</STRONG>'
  end
end
