require 'test_helper'
require 'hparser/parser'
require 'hparser/block/list'

class QuoteTest < Test::Unit::TestCase
  include HParser::Block
  include HParser::Inline

  def setup
    @parser = HParser::Parser.new
  end

  def parse str
    @parser.parse str
  end

  def test_quote
    assert_equal [Quote.new([P.new([Text.new('a')]),P.new([Text.new('b')])])],
                  parse(<<-END.unindent)
    >>
    a
    b
    <<
    END
  end

  def test_quote_list
    assert_equal [Quote.new([Ul.new(Li.new([Text.new('a')]))])],
                  parse(<<-END.unindent)
    >>
    -a
    <<
    END
  end

  def test_quote_nesting
    assert_equal [Quote.new([P.new([Text.new('a')]),
                             Quote.new([P.new([Text.new('b')])])
                            ])
                 ],
                  parse(<<-END.unindent)
    >>
    a
    >>
    b
    <<
    <<
    END
  end

  def test_quote_with_url
    assert_equal [Quote.new([P.new([Text.new('a')])], 
                            Url.new('http://example.com'))],
                  parse(<<-END.unindent)
    >http://example.com>
    a
    <<
    END
  end

  def test_quote_unmatch
    assert_equal [Quote.new([P.new([Text.new('a')])])],
                  parse(<<-END.unindent)
    >>
    a
    END
  end
end
