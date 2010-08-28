Gem::Specification.new do |s|
  s.name = %q{hparser}
  s.version = "0.3.2"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Yuichi Tateno"]
  s.autorequire = %q{}
  s.date = %q{2008-06-18}
  s.description = %q{}
  s.email = %q{hotchpotch@nospam@gmail.com}
  s.extra_rdoc_files = ["README", "ChangeLog"]
  s.files = ["README", "ChangeLog", "Rakefile", "test/test_inline_html.rb", "test/test_dl.rb", "test/test_id.rb",  "test/test_text.rb", "test/test_block.rb", "test/test_hatena.rb", "test/test_head.rb", "test/test_table.rb", "test/test_pair.rb", "test/test_url.rb", "test/test_inline.rb", "test/test_html.rb", "test/test_helper.rb", "test/test_p.rb", "lib/hparser.rb", "lib/hparser", "lib/hparser/util", "lib/hparser/util/parser.rb", "lib/hparser/util/line_scanner.rb", "lib/hparser/parser.rb", "lib/hparser/block", "lib/hparser/block/p.rb", "lib/hparser/block/super_pre.rb", "lib/hparser/block/dl.rb", "lib/hparser/block/list.rb", "lib/hparser/block/all.rb", "lib/hparser/block/table.rb", "lib/hparser/block/head.rb", "lib/hparser/block/pre.rb", "lib/hparser/block/pair.rb", "lib/hparser/block/quote.rb", "lib/hparser/block/collectable.rb", "lib/hparser/text.rb", "lib/hparser/inline", "lib/hparser/inline/parser.rb", "lib/hparser/inline/hatena_id.rb", "lib/hparser/inline/text.rb", "lib/hparser/inline/all.rb", "lib/hparser/inline/url.rb", "lib/hparser/inline/collectable.rb", "lib/hparser/hatena.rb", "lib/hparser/html.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://hparser.rubyforge.org}
  s.rdoc_options = ["--title", "hparser documentation", "--charset", "utf-8", "--opname", "index.html", "--line-numbers", "--main", "README", "--inline-source", "--exclude", "^(examples|extras)/"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{hparser}
  s.rubygems_version = %q{1.1.2}
  s.summary = %q{}
  s.test_files = ["test/test_inline_html.rb", "test/test_dl.rb", "test/test_id.rb", "test/test_text.rb", "test/test_block.rb", "test/test_hatena.rb", "test/test_head.rb", "test/test_table.rb", "test/test_pair.rb", "test/test_url.rb", "test/test_inline.rb", "test/test_html.rb", "test/test_helper.rb", "test/test_p.rb"]
end
