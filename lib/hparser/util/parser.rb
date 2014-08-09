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

    class AllParser
      # Retutrn array of all usable parser.
      #
      # This method collect all classes/modules which include
      # mod module. And sorting those by <=>.
      def self.includes(mod)
        parser = []
        ObjectSpace.each_object(Class){|klass|
          if klass.include?(mod) then
            parser.push klass
          end
        }

        # sorting parser.
        # e.g. Parser P should be after any other parser.
        parser.sort{|a,b|
          a <=> b or -(b <=> a).to_i
        }
      end
    end
  end
end

