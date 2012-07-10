require 'test_helper'
require 'hparser/inline/all'
require 'hparser/parser'
require 'hparser/html'

class HtmlInlineTest < Test::Unit::TestCase
  include HParser::Inline
  def setup
    @parser = Parser.new
  end

  def assert_html expect,str
    expect.class == String and (expect = [expect])

    context = HParser::Context.new
    assert_equal expect,@parser.parse(str, context).map{|x| x.to_html}
  end

  def assert_same str
    assert_html [str],str
  end

  def test_text
    assert_same 'foo is bar'
    assert_same '<a href="http://mzp.sakura.ne.jp">link!</a>'
    assert_same "<img src='http://example.com/' />"
    assert_same '<img src="http://example.com/" />'
    assert_same '<iframe src="http://example.com/"></iframe>'
    assert_same '<a href="http://example.com/"></a>'
  end

  def test_id
    assert_html '<a href="http://d.hatena.ne.jp/mzp/">id:mzp</a>','id:mzp'
    assert_html '<a href="http://d.hatena.ne.jp/mzp/" class="hatena-id-icon">' +
                '<img src="http://www.st-hatena.com/users/mz/mzp/profile_s.gif" ' +
                'width="16" height="16" alt="id:mzp" class="hatena-id-icon">id:mzp</a>',
                'id:mzp:detail'
  end

  def test_url
    assert_html '<a href="http://mzp.sakura.ne.jp">http://mzp.sakura.ne.jp</a>',
                'http://mzp.sakura.ne.jp'
    assert_html '<a href="http://example.com/">TITLE</a>',
                '[http://example.com/:title=TITLE]'
    assert_html '<a href="http://example.com/#a">TITLE</a> ' + 
                '<a href="http://b.hatena.ne.jp/entry/http://example.com/%23a" class="http-bookmark">' + 
                '<img src="http://b.hatena.ne.jp/entry/image/http://example.com/%23a" alt="" class="http-bookmark"></a>',
                '[http://example.com/#a:title=TITLE:bookmark]'
  end

  def test_fotolife
    assert_html '<a href="http://f.hatena.ne.jp/nitoyon/20100718010346">' + 
                '<img src="http://f.hatena.ne.jp/images/fotolife/n/nitoyon/20100718/20100718010346.jpg"></a>',
                '[f:id:nitoyon:20100718010346j:image]'
  end

  def test_tex
    assert_html '<img src="http://chart.apis.google.com/chart?cht=tx&chf=bg,s,00000000&chl=e%5E%7Bi%5Cpi%7D+%3D+-1"' +
                ' class="tex" alt="e^{i\pi} = -1">',
                '[tex:e^{i\pi} = -1]'
  end

  def test_footnote
    assert_html '<span class="footnote"><a href="#f1" title="text" name="fn1">*1</a></span>',
                '((<a href="#">text</a>))'
  end
end
