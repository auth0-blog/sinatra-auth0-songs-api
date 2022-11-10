# frozen_string_literal: true

# Class to represent a Song
class Song
  attr_accessor :id, :name, :url

  def initialize(id, name, url)
    @id = id
    @name = name
    @url = url
  end

  def to_json(*a)
    {
      'id' => id,
      'name' => name,
      'url' => url
    }.to_json(*a)
  end
end
