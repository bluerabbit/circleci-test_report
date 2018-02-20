require "thor"
require "circleci/test_report"

module CircleCI
  module TestReport
    class Cli < Thor
      default_command :convert

      desc "convert", "Create JUnit format xml"
      method_option :file,   aliases: "-f", required: true,  desc: "rspec file path"
      method_option :output, aliases: "-o", required: false, desc: "JUnit format xml file path"

      def convert
        xml = CircleCI::TestReport.create_xml(rspec_json: File.read(options[:file]))
        if output_path = options[:output]
          File.open(output_path, "w+") { |file| file.write xml }
        else
          puts xml
        end
      end

      desc "version", "Show Version"

      def version
        say "Version: #{CircleCI::TestReport::VERSION}"
      end
    end
  end
end
