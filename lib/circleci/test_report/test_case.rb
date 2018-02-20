module CircleCI
  module TestReport
    class TestCase
      attr_accessor :classname, :name, :file, :time, :failure, :skipped

      def initialize
        @classname = ""
        @name      = ""
        @file      = ""
        @time      = ""
        @failure   = nil # {message: '', type: '', text: ''}
        @skipped   = false
      end
    end
  end
end
