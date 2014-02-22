require 'urza/card'
require 'test_helper'

module Urza
  class UrzaScanTest < ActiveSupport::TestCase
    def setup
      @card = YAML.load(File.read('test/fixtures/rakdos_ragemutt.yml'))
      FileUtils.cp('test/fixtures/rakdos_ragemutt.jpg', 'tmp/rakdos_ragemutt.jpg')
      @scan = Urza::Scan.new('tmp/rakdos_ragemutt.jpg')
    end

    def teardown
      FileUtils.rm('tmp/rakdos_ragemutt.jpg')
    end

    def test_crop_refreshes_a_scans_fingerprint
      old_print = @scan.fingerprint
      @scan.crop(:top, 5)

      refute_equal old_print, @scan.fingerprint
    end

    def test_crop_top_decreases_the_height_of_the_image
      old_height = @scan.height
      @scan.crop(:top, 10)

      assert_equal old_height - 10, @scan.height
    end

    def test_crop_right_decreases_the_width_of_the_image
      old_width = @scan.width
      @scan.crop(:right, 10)

      assert_equal old_width - 10, @scan.width
    end

    def test_crop_bottom_decreases_the_height_of_the_image
      old_height = @scan.height
      @scan.crop(:bottom, 10)

      assert_equal old_height - 10, @scan.height
    end

    def test_crop_left_decreases_the_width_of_the_image
      old_width = @scan.width
      @scan.crop(:left, 10)

      assert_equal old_width - 10, @scan.width
    end

    if ENV['TEST_SLOW']
      def test_calculate_crop_edge_returns_the_pixels_to_crop_from_the_top
        result = @scan.calculate_crop_edge(:top, @card.fingerprint.to_i)
        assert_equal 75, result
      end

      def test_calculate_crop_edge_returns_the_pixels_to_crop_from_the_right
        result = @scan.calculate_crop_edge(:right, @card.fingerprint.to_i)
        assert_equal 30, result
      end

      def test_calculate_crop_edge_returns_the_pixels_to_crop_from_the_bottom
        result = @scan.calculate_crop_edge(:bottom, @card.fingerprint.to_i)
        assert_equal 15, result
      end

      def test_calculate_crop_edge_returns_the_pixels_to_crop_from_the_left
        result = @scan.calculate_crop_edge(:left, @card.fingerprint.to_i)
        assert_equal 35, result
      end

      def test_calculate_crop_edges_returns_the_pixels_to_crop_from_each_edge
        expected = {
          :top => 75,
          :right => 30,
          :bottom => 15,
          :left => 35
        }

        result = @scan.calculate_crop_edges(@card.fingerprint.to_i)
        assert_equal expected, result
      end
    end

    def test_crop_edges_crops_each_edge_by_the_given_pixels
      original_width, original_height = @scan.width, @scan.height
      @scan.crop_edges(top: 10, right: 20, bottom: 30, left: 40)
      assert_equal original_width - 60, @scan.width
      assert_equal original_height - 40, @scan.height
    end
  end
end
