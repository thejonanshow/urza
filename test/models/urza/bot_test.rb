require 'minitest/autorun'

module Urza
  class UrzaBotTest < ActiveSupport::TestCase
    def setup
      @fake_brick = MiniTest::Mock.new
      @bot = Urza::Bot.new(@fake_brick)
    end

    def test_run_motor_for_duration_calls_run_then_stop
      @fake_brick.expect(:run_motor, nil, [:c, 100])
      @fake_brick.expect(:stop_motor, nil, [:c])
      @bot.run_motor_for_duration(:c, 100, 0)
    end

    def test_eject_runs_motor_c_for_half_a_second_at_60
      @fake_brick.expect(:run_motor_for_duration, nil, [:c, -60, 0.5])
      @fake_brick.expect(:run_motor_for_duration, nil, [:c, 60, 0.5])
      @bot.eject(0)
    end
  end
end
