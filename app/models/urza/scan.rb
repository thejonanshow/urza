require 'phashion'
require 'rmagick'

module Urza
  class Scan
    attr_reader :path, :phashion_image, :magick_image

    def initialize(image_path)
      @path = image_path
      load_images
    end

    def load_images
      @phashion_image = Phashion::Image.new(self.path)
      @magick_image = Magick::Image::read(self.path).first
    end

    def fingerprint
      self.phashion_image.fingerprint
    end

    def crop(edge, pixels)
      if edge == :top
        self.magick_image.crop(0, pixels, width, height - pixels).write(self.path)
      elsif edge == :right
        self.magick_image.crop(0, 0, width - pixels, height).write(self.path)
      elsif edge == :bottom
        self.magick_image.crop(0, 0, width, height - pixels).write(self.path)
      elsif edge == :left
        self.magick_image.crop(pixels, 0, width - pixels, height).write(self.path)
      end

      load_images
    end

    def width
      self.magick_image.columns
    end

    def height
      self.magick_image.rows
    end

    def crop_edges(edge_pixels)
      edge_pixels.each do |edge, pixels|
        crop(edge, pixels)
      end
    end

    def calibrate_crop_edge(edge, fingerprint)
      hamming_distances = {}
      current_crop = 0

      if edge == :top || edge == :bottom
        max_crop = height * 0.1
      else
        max_crop = width * 0.1
      end

      while current_crop < max_crop
        crop(edge, 5)
        current_crop += 5
        puts "Cropped #{current_crop} from the #{edge} so far out of #{max_crop}" if ENV['DEBUG']

        hamming_distance = Phashion.hamming_distance(self.phashion_image.fingerprint, fingerprint)
        hamming_distances[hamming_distance] = current_crop
      end

      hamming_distances.sort.first.last
    end
  end
end
