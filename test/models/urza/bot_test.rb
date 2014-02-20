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

    def test_dispense_runs_motor_b_until_light_changes
      @fake_brick.expect(:run_motor, nil, [:b, -80])
      @fake_brick.expect(:light_sensor, 0, [1])
      @fake_brick.expect(:light_sensor, 7, [1])
      @fake_brick.expect(:stop_motor, nil, [:b])
      @bot.dispense
    end

    def test_dispense_tries_to_dispense_again_on_wait_for_light_change_timeout
      @fake_brick.expect(:run_motor, nil, [:b, -80])
      @fake_brick.expect(:light_sensor, 0, [1])
      @fake_brick.expect(:stop_motor, nil, [:b])

      @fake_brick.expect(:run_motor, nil, [:b, -80])
      @fake_brick.expect(:light_sensor, 7, [1])
      @fake_brick.expect(:stop_motor, nil, [:b])

      @bot.dispense
    end

    def test_dispense_ejects_the_scanned_card
      @fake_brick.expect(:run_motor, nil, [:b, -80])
      @fake_brick.expect(:light_sensor, 0, [1])
      @fake_brick.expect(:light_sensor, 7, [1])
      @fake_brick.expect(:stop_motor, nil, [:b])
      @bot.dispense
    end

    def test_wait_for_light_change_loops_until_timeout
      @fake_brick.expect(:light_sensor, 0, [1])
      @bot.wait_for_light_change(0)
    end

    def test_wait_for_light_change_loops_until_light_increases_by_seven
      @fake_brick.expect(:light_sensor, 0, [1])
      @fake_brick.expect(:light_sensor, 7, [1])
      @bot.wait_for_light_change
    end

    def test_wait_for_light_change_returns_true_if_light_changes
      @fake_brick.expect(:light_sensor, 0, [1])
      @fake_brick.expect(:light_sensor, 7, [1])
      assert @bot.wait_for_light_change
    end

    def test_wait_for_light_change_returns_false_on_timeout
      @fake_brick.expect(:light_sensor, 0, [1])
      refute @bot.wait_for_light_change(0)
    end
  end
end
