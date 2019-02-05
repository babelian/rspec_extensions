# https://ieftimov.com/how-to-write-rspec-formatters-from-scratch
require 'rspec/core/formatters/console_codes'

class SuiteFormatter
  RSpec::Core::Formatters.register self,
                                   #:dump_pending,
                                   :dump_failures,
                                   :close,
                                   :dump_summary,
                                   :example_passed,
                                   :example_failed,
                                   :example_pending

  def initialize output
    @output = output
  end

  def example_passed notification # ExampleNotification
    @output << RSpec::Core::Formatters::ConsoleCodes.wrap(".", :success)
  end

  def example_failed notification # FailedExampleNotification
    @output << RSpec::Core::Formatters::ConsoleCodes.wrap("F", :failure)
  end

  def example_pending notification # ExampleNotification
    @output << RSpec::Core::Formatters::ConsoleCodes.wrap("*", :pending)
  end

  def dump_pending notification # ExamplesNotification
    if notification.pending_examples.length > 0
      @output << "\n\n#{RSpec::Core::Formatters::ConsoleCodes.wrap("PENDING:", :pending)}\n\t"
      @output << notification.pending_examples.map {|example| example.full_description + " - " + example.location }.join("\n\t")
    end
  end

  def dump_failures notification # ExamplesNotification
    if notification.failed_examples.length > 0
      @output << "\n#{RSpec::Core::Formatters::ConsoleCodes.wrap("FAILING:", :failure)}\n\t"
      @output << failed_examples_output(notification)
    end
  end

  def dump_summary notification # SummaryNotification
    @output << "\n\nFinished in #{RSpec::Core::Formatters::Helpers.format_duration(notification.duration)}."
  end

  def close notification # NullNotification
    @output << "\n"
  end

  private

  # Loops through all of the failed examples and rebuilds the exception message
  def failed_examples_output notification
    failed_examples_output = notification.failed_examples.map do |example|
      failed_example_output example
    end
    build_examples_output(failed_examples_output)
  end

  # Joins all exception messages
  def build_examples_output output
    output.join("\n\n\t")
  end

  # Extracts the full_description, location and formats the message of each example exception
  def failed_example_output example
    full_description = example.full_description
    location = example.location
    formatted_message = strip_message_from_whitespace(example.execution_result.exception.message)

    "#{full_description} - #{location} \n  #{formatted_message}"
  end

  # Removes whitespace from each of the exception message lines and reformats it
  def strip_message_from_whitespace msg
    msg.split("\n").map(&:strip).join("\n#{add_spaces(10)}")
  end

  def add_spaces n
    " " * n
  end
end