require 'test_helper'
require 'hparser/parser'
require 'hparser/block/table'
require 'hparser/block/p'

class TableTest < Test::Unit::TestCase
  include HParser::Block
  include HParser::Inline

  def setup
    @parser = HParser::Parser.new [Table,P]
  end

  def parse str
    @parser.parse str
  end

  def test_table
    assert_equal [Table.new([th('name'),th('desc')       ],
                            [td('foo') ,td('foo is ....')],
                            [td('bar') ,td('bar is ....')])],
                  parse(<<-END)
|*name|*desc      |
|foo  |foo is ....|
|bar  |bar is ....|
    END
  end

  def th str
    Th.new [Text.new(str)]
  end

  def td str
    Td.new [Text.new(str)]
  end

  def test_p
    assert_equal [P.new([Text.new("a|aa")])], parse("a|aa")
  end
end
