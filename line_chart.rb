require 'line_chart_builder'

class LineChart < Chart
  LINE_CHART_TYPES = { :line_chart => 'lc', :sparkline  => 'ls', :scatter => 'lxy' }

  include CommonParams::ChartAxes
  include CommonParams::ChartColors
  include CommonParams::ChartLegend
  include CommonParams::ChartMarkers
  include CommonParams::ChartTitle

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
