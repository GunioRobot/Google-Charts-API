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
