require 'test_helper'
require 'hparser/block/all'
require 'hparser/inline/all'
require 'hparser/latex'

class LatexTest < Test::Unit::TestCase
  include HParser::Block
  include HParser::Inline
  def setup
#    @parser = HParser::Parser.new
  end

  def assert_latex expect,node
    assert_equal expect,node.to_latex
  end

  def test_blank
    parser = HParser::Parser.new
    assert_equal parser.parse(''), []
  end

  def test_head
    assert_equal Head.head_level, 1
    assert_latex "\\section{foo}\n\n",Head.new(1,[Text.new('foo')])
    Head.head_level = 2
    assert_latex "\\subsection{foo}\n\n",Head.new(1,[Text.new('foo')])
    Head.head_level = 4
    assert_latex "\\paragraph{foo}\n\n",Head.new(1,[Text.new('foo')])
    Head.head_level = 1
  end


  def test_p
    assert_latex "foobar\n\n",P.new([Text.new('foobar')])
    assert_latex "\n\n",Empty.new
  end

  def test_pre
    assert_latex "\\begin{verbatim}\nfoobar\n\\end{verbatim}\n",Pre.new([Text.new('foobar')])
    assert_latex "\\begin{verbatim}\nfoobar\n\\end{verbatim}\n",SuperPre.new('foobar')
  end

  def test_quote
    assert_latex "\\begin{quotation}\nfoobar\n\n\n\\end{quotation}\n",Quote.new([P.new([Text.new('foobar')])])
  end

  def test_table
    table = <<EOB
\\begin{table}
  \\centering
  \\begin{tabular}{ l l }
    foo & bar \\\\
    baz & xyzzy \\\\
  \\end{tabular}
\\end{table}
EOB
    assert_latex table,
                Table.new([th('foo'),th('bar')],
                          [td('baz') ,td('xyzzy')])
  end

  def test_list
    assert_latex "\\begin{itemize}\n  \\item aaa\n\n  \\item bbb\n\n\\end{itemize}\n",Ul.new(Li.new([Text.new('aaa')]),Li.new([Text.new('bbb')]))
    assert_latex "\\begin{enumerate}\n  \\item aaa\n\n  \\item bbb\n\n\\end{enumerate}\n",Ol.new(Li.new([Text.new('aaa')]),Li.new([Text.new('bbb')]))
#    assert_latex '<ol><ul><li>aaa</li></ul><li>bbb</li></ol>',Ol.new(Ul.new(Li.new([Text.new('aaa')])),
#                                                                    Li.new([Text.new('bbb')]))
  end

  def test_dl
    expect = <<EOB
\\begin{description}
\\item[foo] \\quad \\\\
foo is ...
\\item[bar] \\quad \\\\
bar is ...

\\end{description}
EOB

    first = Dl::Item.new([Text.new('foo')],[Text.new('foo is ...')])
    second = Dl::Item.new([Text.new('bar')],[Text.new('bar is ...')])
    assert_latex expect,Dl.new(first,second)
  end

  def th str
    Th.new [Text.new(str)]
  end

  def td str
    Td.new [Text.new(str)]
  end

end
