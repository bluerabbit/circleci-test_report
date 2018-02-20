RSpec.describe CircleCI::TestReport do
  it "has a version number" do
    expect(CircleCI::TestReport::VERSION).not_to be nil
  end

  describe ".create_xml_from_rspec_json" do
    subject { CircleCI::TestReport.create_xml(rspec_json: rspec_hash.to_json, timestamp: "2018-01-01T00:00:00+00:00") }

    context "example is passed" do
      let(:rspec_hash) do
        { "version" => "3.7.1",
         "examples" => [
           { "id" => "./spec/your_spec.rb[1:1]",
            "description"      => "description",
            "full_description" => "full_description",
            "status"           => "passed",
            "file_path"        => "./spec/your_spec.rb",
            "line_number"      => 2,
            "run_time"         => 0.000001,
            "pending_message"  => nil },
         ],
         "summary" => {
           "duration"                         => 0.000001,
           "example_count"                    => 1,
           "failure_count"                    => 0,
           "pending_count"                    => 0,
           "errors_outside_of_examples_count" => 0
         },
         "summary_line" => "1 examples, 0 failure, 0 pending" }
      end

      it do
        is_expected.to eq(['<?xml version="1.0" encoding="UTF-8"?>',
                           '<testsuite name="rspec" tests="1" skipped="0" failures="0" errors="0" time="1.0e-06" timestamp="2018-01-01T00:00:00+00:00" hostname="unknown">',
                           "<properties>",
                           '<property name="seed" value="0"/>',
                           "</properties>",
                           '<testcase classname="spec.your_spec" name="full_description" file="./spec/your_spec.rb" time="1.0e-06">',
                           "</testcase>",
                           "</testsuite>"].join)
      end
    end

    context "example is pending" do
      let(:rspec_hash) do
        { "version" => "3.7.1",
         "examples"     => [
           { "id" => "./spec/your_spec.rb[1:2]",
            "description"      => "description",
            "full_description" => "full_description",
            "status"           => "pending",
            "file_path"        => "./spec/your_spec.rb",
            "line_number"      => 5,
            "run_time"         => 1.0e-05,
            "pending_message"  => "Temporarily skipped with xit" },
         ],
         "summary" => {
           "duration"                         => 0.000001,
           "example_count"                    => 1,
           "failure_count"                    => 0,
           "pending_count"                    => 1,
           "errors_outside_of_examples_count" => 0
         },
         "summary_line" => "1 examples, 0 failure, 1 pending" }
      end

      it do
        is_expected.to eq(['<?xml version="1.0" encoding="UTF-8"?>',
                           '<testsuite name="rspec" tests="1" skipped="1" failures="0" errors="0" time="1.0e-06" timestamp="2018-01-01T00:00:00+00:00" hostname="unknown">',
                           "<properties>",
                           '<property name="seed" value="0"/>',
                           "</properties>",
                           '<testcase classname="spec.your_spec" name="full_description" file="./spec/your_spec.rb" time="1.0e-05">',
                           "<skipped/>",
                           "</testcase>",
                           "</testsuite>"].join)
      end
    end

    context "example is failed" do
      let(:rspec_hash) do
        { "version" => "3.7.1",
         "examples"     => [
           { "id" => "./spec/your_spec.rb[1:3:1]",
            "description"      => "example at ./spec/your_spec.rb:10",
            "full_description" => "full_description",
            "status"           => "failed",
            "file_path"        => "./spec/your_spec.rb",
            "line_number"      => 10,
            "run_time"         => 0.000001,
            "pending_message"  => nil,
            "exception"        => {
              "class"     => "RuntimeError",
              "message"   => "error message",
              "backtrace" => ["/path/to/spec/your_spec.rb:2:in `foo'",
                              "/path/to/spec/your_spec.rb:1:in `<main>'"]
            } }],
         "summary"      => {
           "duration"                         => 0.000001,
           "example_count"                    => 1,
           "failure_count"                    => 1,
           "pending_count"                    => 0,
           "errors_outside_of_examples_count" => 0
         },
         "summary_line" => "1 examples, 1 failure, 0 pending" }
      end

      it do
        is_expected.to eq(['<?xml version="1.0" encoding="UTF-8"?>',
                           '<testsuite name="rspec" tests="1" skipped="0" failures="1" errors="0" time="1.0e-06" timestamp="2018-01-01T00:00:00+00:00" hostname="unknown">',
                           "<properties>",
                           '<property name="seed" value="0"/>',
                           "</properties>",
                           '<testcase classname="spec.your_spec" name="full_description" file="./spec/your_spec.rb" time="1.0e-06">',
                           %Q(<failure message="error message" type="RuntimeError">/path/to/spec/your_spec.rb:2:in `foo'\n/path/to/spec/your_spec.rb:1:in `&lt;main&gt;'</failure>),
                           "</testcase>",
                           "</testsuite>"].join)
      end
    end
  end
end
