require 'lego_nxt'

module Urza
  class Bot
    attr_reader :brick, :cards
    attr_accessor :config

    def initialize(brick = nil)
      @config = {
        :default_motor_duration => 1,
        :light_timeout => 3,
        :light_threshold => 7,
        :dispense_retries => 3,
        :sort_motor => :a,
        :dispense_motor => :c,
        :eject_motor => :b,
        :eject_pause => 0.1
      }
      begin
        @brick = brick || LegoNXT::LowLevel.connect
      rescue
        raise BotInitializationError.new('Unable to connect to Lego NXT brick')
      end

      @cards = Urza::Card.includes(:fingerprints).all.to_a
      return nil
    end

    def prepare_scan
      scan = Urza::Scan.new
      scan.crop_edges
      scan.preview
      scan
    end

    def learn(dispense_new_card = true)
      dispense if dispense_new_card
      scan = prepare_scan
      distances_with_cards = Urza::Fingerprint.hamming_distances(scan.fingerprint, self.cards).sort

      identify_card(distances_with_cards[0..2])
    end

    def identify_card(distances_with_cards)
      cards = distances_with_cards.map(&:last).flatten
      duplicate_count = cards.length - cards.uniq.length

      if duplicate_count > 1
        common_card = most_common_value(cards)
        puts "This is #{common_card.full_name}" if common_card
      end
    end

    def most_common_value(array)
      array.group_by do |element|
        element
      end.values.max_by(&:size).first
    end

    def stop
      self.brick.stop_motor(:all)
    end

    def run_motor_for_duration(motor, speed = 100, duration = config[:default_motor_duration])
      self.brick.run_motor(motor, speed)
      sleep duration
      self.brick.stop_motor(motor)
    end

    def eject(pause = config[:eject_pause])
      run_motor_for_duration(config[:eject_motor], -60, 0.4)
      sleep pause
      run_motor_for_duration(config[:eject_motor], 60, 0.4)
    end

    def wait_for_light_change(timeout = self.config[:light_timeout])
      starting_time = Time.now
      light = starting_light = self.brick.light_sensor(1)

      while (Time.now - starting_time) < timeout && (light - starting_light < config[:light_threshold])
        light = self.brick.light_sensor(1)
      end

      if light - starting_light >= config[:light_threshold]
        true
      else
        false
      end
    end

    def dispense(retries = self.config[:dispense_retries])
      return false unless retries > 0
      eject

      self.brick.run_motor(config[:dispense_motor], -80)
      success = wait_for_light_change
      sleep 0.5
      self.brick.stop_motor(config[:dispense_motor])

      if success
        true
      else
        dispense(retries - 1)
      end
    end
  end
  class BotInitializationError < StandardError; end
end
