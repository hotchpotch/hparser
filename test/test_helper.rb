
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib/')
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/hparser'


class String
	def unindent(leading=nil)
		gsub(/^#{self[Regexp.union(leading || /\A(?:\t+| +)/)]}/, "")
	end
end
