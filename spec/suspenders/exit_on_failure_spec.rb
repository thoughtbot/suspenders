require "spec_helper"

RSpec.describe Suspenders::ExitOnFailure do
  def make_generator_class(&block)
    Class.new Rails::Generators::AppBase do
      include Suspenders::ExitOnFailure

      class_eval(&block)
    end
  end

  def generator_exit_status(generator_class)
    pid = fork do
      OutputStub.silence { generator_class.start }
    end

    Process.wait(pid)

    $CHILD_STATUS.exitstatus.zero? ? :exit_success : :exit_failure
  end

  it "exits with failure status on generator error" do
    generator_class = make_generator_class do
      def generator_task
        copy_file "non_existing_file", "non_existing_destination"
      end
    end

    expect(generator_exit_status(generator_class)).to be :exit_failure
  end

  it "exits with failure status on bundle command error" do
    generator_class = make_generator_class do
      def generator_task
        bundle_command "non_existing_bundle_command 2> /dev/null"
      end
    end

    expect(generator_exit_status(generator_class)).to be :exit_failure
  end
end
