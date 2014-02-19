require 'lego_nxt'

module Urza
  class Bot
    attr_reader :brick

    def initialize(brick = nil)
      begin
        @brick = brick || LegoNXT::LowLevel.connect
      rescue
        raise BotInitializationError.new('Unable to connect to Lego NXT brick')
      end
    end

    def run_motor_for_duration(motor, speed = 100, duration = 1)
      self.brick.run_motor(:c, speed)
      sleep duration
      self.brick.stop_motor(:c)
    end

    def eject(pause = 0.3)
      self.brick.run_motor_for_duration(:c, -60, 0.5)
      sleep pause
      self.brick.run_motor_for_duration(:c, 60, 0.5)
    end
  end
  class BotInitializationError < StandardError; end
end
