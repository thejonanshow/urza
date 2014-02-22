require 'phashion'
require 'rmagick'
require 'av_capture'

module Urza
  class Scan
    attr_reader :phashion_image, :magick_image
    attr_accessor :path

    def initialize(image_path = nil)
      @path = image_path || capture
      load_images
    end

    def load_images
      @phashion_image = Phashion::Image.new(self.path)
      @magick_image = Magick::Image::read(self.path).first
    end

    def capture
      session = AVCapture::Session.new # AVCaptureSession
      dev = AVCapture.devices.find(&:video?) # AVCaptureDevice
      filename = "tmp/urza_scan.jpg"

      output = AVCapture::StillImageOutput.new # AVCaptureOutput subclass
      session.add_input dev.as_input
      session.add_output output

      session.run do
        connection = output.video_connection

        ios = 1.times.map {
          io = output.capture_on connection
          sleep 0.5
          io
        }

        ios.each_with_index do |io, i|
          File.open("tmp/urza_scan.jpg", 'wb') { |f| f.write io.data }
        end

        filename = "tmp/urza_scan.jpg"
      end
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

    def calculate_crop_edge(edge, fingerprint)
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
        puts "Working with #{self.path}" if ENV['DEBUG']
        puts "Cropped #{current_crop} from the #{edge} so far out of #{max_crop}" if ENV['DEBUG']

        hamming_distance = Phashion.hamming_distance(self.phashion_image.fingerprint, fingerprint)
        hamming_distances[hamming_distance] = current_crop
      end

      hamming_distances.sort.first.last
    end

    def calculate_crop_edges(fingerprint)
      edges = {
        :top => nil,
        :right => nil,
        :bottom => nil,
        :left => nil
      }
      edges.keys.each do |edge|
        self.magick_image.write("tmp/calculate_#{edge}_crop.jpg")
      end

      edges.keys.each do |edge|
        self.path = "tmp/calculate_#{edge}_crop.jpg"
        load_images
        edges[edge] = calculate_crop_edge(edge, fingerprint)
      end

      edges
    end
  end
end
