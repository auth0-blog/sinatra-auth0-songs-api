# frozen_string_literal: true

require_relative '../models/song'
require 'json'

# Class to read songs from a JSON file
class SongsHelper
  def self.songs
    filepath = File.join(File.dirname(__FILE__), '../songs.json')
    file = File.read(filepath)
    data = JSON.parse(file)['songs']

    data.map do |song|
      Song.new(song['id'], song['name'], song['url'])
    end
  end
end
