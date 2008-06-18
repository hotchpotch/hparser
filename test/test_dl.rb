require 'test_helper'
require 'hparser/parser'
require 'hparser/block/dl'

class DlTest < Test::Unit::TestCase
  include HParser::Block
  include HParser::Inline

  def setup
    @parser = HParser::Parser.new [Dl]
  end

  def parse str
    @parser.parse str
  end

  def test_dl
    first = Dl::Item.new([Text.new('foo')],[Text.new('foo is ...')])
    second = Dl::Item.new([Text.new('bar')],[Text.new('bar is ...')])
    assert_equal [Dl.new(first,second)],
                  parse(<<-END)
:foo:foo is ...
:bar:bar is ...
                  END
  end
end
