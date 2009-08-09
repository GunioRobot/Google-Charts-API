class LineChart < Chart
  LINE_CHART_TYPES = { :line_chart => 'lc', :sparkline  => 'ls', :scatter => 'lxy' }

  include CommonParams::ChartColors
  include CommonParams::ChartLegend
  include CommonParams::ChartTitle
  include CommonParams::ChartMarkers

  def initialize options = {}
    self.type = options.delete(:type) || :line_chart
    super
  end

  def self.build title = nil, &block
    builder = LineChartBuilder.new(:title => title)
    builder.instance_eval &block
    builder.chart
  end

  def type= type
    raise 'Invalid Chart Type' unless LINE_CHART_TYPES.include?(type)
    @type = LINE_CHART_TYPES[type]
  end
end

class LineChartBuilder
  attr_reader :chart

  def initialize options = {}
    @chart = LineChart.new :title => options[:title]
  end

  def data dataset
    @chart.datasets << dataset
  end

  def size string
    @chart.send :size=, string
  end
end
