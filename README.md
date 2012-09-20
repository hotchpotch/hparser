=Hatena Format Parser

== Description

+hparser+ is hatena format parser. This format is used at hatena diary(http://d.hatena.ne.jp/)
If you want to know more detail about hatena format, please see http://hatenadiary.g.hatena.ne.jp/keyword/%e3%81%af%e3%81%a6%e3%81%aa%e8%a8%98%e6%b3%95%e4%b8%80%e8%a6%a7

+hpaser+ is constructed with some little parser.(e.g. header parser,list parser,and ...)
So,+hparser+ can be added new format,or removed unused format.

== Installation

=== Archive Installation

 rake install

=== Gem Installation

 gem install hotchpotch-hparser


== Features/Problems


== Synopsis

To parse hatena format,please use HParser::Parser.

 require 'hparser'
 
 parser = HParser::Parser.new
 puts parser.parse(hatena_syntax).map {|e| e.to_html }.join("\n")


== Copyright

Author:: HIROKI Mizuno(Original Author), Yuichi Tateno<hotchpotch@nospam@gmail.com>, Nitoyon
Copyright:: HIROKI Mizuno, Yuichi Tateno
License:: Ruby's

