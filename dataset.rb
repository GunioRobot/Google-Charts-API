class Dataset
  attr_accessor :markers, :name
  attr_writer   :color,   :data

  def initialize options = {}
    self.data    = options.delete :data
    self.markers = []
    options.each { |k,v| instance_variable_set "@#{k}", v }
  end

  def self.build name = nil, &block
    builder = DatasetBuilder.new(:name => name)
    builder.instance_eval &block
    builder.dataset
  end

  def color
    @color.to_hex_color unless @color.blank?
  end

  def data
    raise "Data should not be empty" if     @data.blank?
    raise "Data should be an array"  unless @data.is_a? Array
    @data
  end

  def encoded_data encoding = :text
    return @data.join(',') if encoding == :text
    @data.map { |n| n.blank? ? '_' : n.send(encoding) }.join('')
  end

  def marker_string index = nil
    result = @markers.collect { |m| m.to_s index }
    result.blank? ? nil : result.join('|')
  end
end

class DatasetBuilder
  attr_reader :dataset

  def initialize options = {}
    @dataset = Dataset.new :name => options[:name]
  end

  def color value
    @dataset.color = value
  end

  def data array
    @dataset.data = array
  end

  def marker marker
    @dataset.markers << marker
  end

end
