require "builder"

module CircleCI
  module TestReport
    class TestSuite
      attr_accessor :name, :tests, :skipped, :failures, :errors, :time, :timestamp, :seed, :test_cases, :hostname

      def initialize
        @test_cases = []
        @name       = ""
        @tests      = 0
        @skipped    = 0
        @failures   = 0
        @errors     = 0
        @time       = 0
        @timestamp  = nil
        @seed       = 0
        @hostname   = ""
      end

      def add_test_case(testcase)
        @test_cases << testcase
      end

      def to_xml
        xml_markup = Builder::XmlMarkup.new
        xml_markup.instruct!
        xml_markup.testsuite(name:      name,
                             tests:     tests,
                             skipped:   skipped,
                             failures:  failures,
                             errors:    errors,
                             time:      time,
                             timestamp: timestamp,
                             hostname:  hostname) do |testsuite|

          testsuite.properties { |p| p.property(name: "seed", value: seed) }

          test_cases.each do |test_case|
            testsuite.testcase(classname: test_case.classname,
                               name:      test_case.name,
                               file:      test_case.file,
                               time:      test_case.time) do |t|
              if test_case.failure
                t.failure(message: test_case.failure[:message], type: test_case.failure[:type]) do |f|
                  f.text! test_case.failure[:text]
                end
              elsif test_case.skipped
                t.skipped
              end
            end
          end
        end
      end
    end
  end
end
