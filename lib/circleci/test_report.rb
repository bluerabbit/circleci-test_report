require "circleci/test_report/version"
require "circleci/test_report/test_case"
require "circleci/test_report/test_suite"
require "time"
require "json"

module CircleCI
  module TestReport
    class << self
      def create_xml(rspec_json:, timestamp: Time.now.iso8601, hostname: "unknown")
        rspec_hash = JSON.parse(rspec_json)
        summary    = rspec_hash["summary"]

        suite           = TestSuite.new
        suite.name      = "rspec"
        suite.tests     = summary["example_count"]
        suite.skipped   = summary["pending_count"]
        suite.failures  = summary["failure_count"]
        suite.errors    = summary["errors_outside_of_examples_count"]
        suite.time      = summary["duration"]
        suite.timestamp = timestamp
        suite.hostname  = hostname
        suite.seed      = 0

        rspec_hash["examples"].each do |example|
          testcase           = TestCase.new
          testcase.classname = example["file_path"].split(".")[1].split("/")[1..-1].join(".")
          testcase.name      = example["full_description"]
          testcase.file      = example["file_path"]
          testcase.time      = example["run_time"]
          case example["status"]
          when "failed"
            testcase.failure = {
              message: example["exception"]["message"],
              type:    example["exception"]["class"],
              text:    example["exception"]["backtrace"].join("\n")
            }
          when "pending"
            testcase.skipped = true
          end
          suite.add_test_case(testcase)
        end

        suite.to_xml
      end
    end
  end
end
