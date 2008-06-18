require 'test/unit'
require 'hparser/inline/all'
require 'hparser/html'

class HtmlInlineTest < Test::Unit::TestCase
  include HParser::Inline
  def setup
    @parser = Parser.new
  end

  def assert_html expect,str
    expect.class == String and (expect = [expect])

    assert_equal expect,@parser.parse(str).map{|x| x.to_html}
  end

  def assert_same str
    assert_html [str],str
  end

  def test_text
    assert_same 'foo is bar'
    assert_same '<a href="http://mzp.sakura.ne.jp">link!</a>'
  end

  def test_id
    assert_html '<a href="http://d.hatena.ne.jp/mzp/">id:mzp</a>','id:mzp'
  end

  def test_url
    assert_html '<a href="http://mzp.sakura.ne.jp">http://mzp.sakura.ne.jp</a>',
                'http://mzp.sakura.ne.jp'
  end
end
