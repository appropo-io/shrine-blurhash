# frozen_string_literal: true

require "bundler/setup"
require "minitest/autorun"
require "shrine"
require "shrine/storage/memory"
require "shrine/plugins/blurhash"

describe Shrine::Plugins::Blurhash do
  before do
    uploader_class = Class.new(Shrine)

    uploader_class.storages[:cache] = Shrine::Storage::Memory.new
    uploader_class.storages[:store] = Shrine::Storage::Memory.new
    uploader_class.class_eval { plugin :blurhash, extractor: :ruby_vips }

    @uploader = uploader_class.new(:store)
  end

  def image
    File.open("test/fixtures/image1.jpg", binmode: true)
  end

  it "automatically computes the blurhash on upload" do
    uploaded_file = @uploader.upload(image)
    assert_equal "LLHV6nae2ek8lAo0aeR*%fkCMxn%", uploaded_file.metadata["blurhash"]
  end
end