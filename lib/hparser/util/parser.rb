module HParser
  module Util
    class Many1
      def initialize(parser)
        @parser = parser
      end
      
      def parse(*args)
        result = []
        while (r = @parser.parse(*args))
          result.push r
        end
        result==[] ? nil : result
      end
    end

    class Skip
      def initialize(parser)
        @parser = parser
      end

      def parse(*args)
        @parser.parse(*args)
        true
      end
    end

    class Concat
      def initialize(*parsers)
        @parsers = parsers
      end
      
      def parse(*args)
        result = []
        for parser in @parsers
          r = parser.parse(*args)
          unless r then
            return nil
          end
          result.push r
        end
        result
      end
    end

    class Or
      def initialize(*parsers)
        @parsers = parsers
      end
      
      def parse(*args)
        r = nil
        for parser in @parsers
          r = parser.parse(*args)
          if r then
            break
          end
        end
        r
      end
    end
    
    class ProcParser
      def initialize(&proc)
        @proc = proc
      end
      
      def parse(*args)
        @proc.call(*args)
      end
    end
  end
end

