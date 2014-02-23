require 'lego_nxt'

module Urza
  class Bot
    attr_reader :brick
    attr_accessor :config

    def initialize(brick = nil)
      @config = {
        :default_motor_duration => 1,
        :light_timeout => 3,
        :light_threshold => 7,
        :dispense_retries => 3,
        :sort_motor => :a,
        :dispense_motor => :b,
        :eject_motor => :c,
        :eject_pause => 0.1
      }
      begin
        @brick = brick || LegoNXT::LowLevel.connect
      rescue
        raise BotInitializationError.new('Unable to connect to Lego NXT brick')
      end
    end

    def learn
      dispense
      sleep 1
      s = Urza::Scan.new
      s.crop_edges
      s.preview
      distances = Urza::Fingerprint.hamming_distances(s.fingerprint)

      card = nil
      response = each_result(distances) do |hamming_distance, card_id|
        loop do
          card = Urza::Card.find(card_id)
          puts "Is it #{card.full_name} from #{card.expansion.name}? (y/n/i(nput)/s(kip)"
          puts "Image: #{card.image_path}"
          case resp = gets.strip
          when 'y', 's', 'i'
            break(resp)
          when 'n'
            break
          end
        end
      end

      card.fingerprints.create(phash: s.fingerprint.to_s) if response == 'y'
    end

    def each_result(distances)
      sorted = distances.keys.sort

      sorted.each do |hamming_distance|
        distances[hamming_distance].each do |card_id|
          result = yield hamming_distance, card_id
          return result if result
        end
      end
    end

    def run_motor_for_duration(motor, speed = 100, duration = config[:default_motor_duration])
      self.brick.run_motor(motor, speed)
      sleep duration
      self.brick.stop_motor(motor)
    end

    def eject(pause = config[:eject_pause])
      run_motor_for_duration(config[:eject_motor], -60, 0.5)
      sleep pause
      run_motor_for_duration(config[:eject_motor], 60, 0.5)
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
      sleep 0.2
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
