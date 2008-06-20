require 'test_helper'
require 'hparser/parser'
require 'hparser/block/list'
require 'pathname'

class BlockTest < Test::Unit::TestCase
  include HParser::Block
  include HParser::Inline

  def setup
    @parser = HParser::Parser.new
  end

  def parse str
    @parser.parse str
  end

  def test_from_cpan_text_hatena
    Pathname.glob(Pathname.new(__FILE__).parent + "test_from_perl/*.t").each do |test|
      data = test.read.gsub(/\r?\n|\r/, "\n")[/__END__\n([\s\S]+)/, 1].split(/^===\s*/)
      data.each do |d|
        name, *rest = d.split(/^--- */)
        rest = rest.inject({}) {|r,i|
          i.sub!(/^(.*)\n/, "")
          r.update(Regexp.last_match[1] => i.strip)
        }
        next unless rest["text"]
        assert_nothing_raised("#{test.basename}::#{name}\n\n#{rest["text"]}\n") {
          @parser.parse rest["text"]
        }
      end
    end
  end
end
