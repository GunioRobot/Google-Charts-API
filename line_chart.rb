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

class LineChartBuilder
  attr_reader :chart

  def initialize options = {}
    @chart = LineChart.new :title => options[:title]
  end

  def axes type, options = {}
    @chart.axes << Axis.new(type, options)
  end

  def dataset value, &block
    if block_given?
      dataset = Dataset.build value do
        instance_eval(&block)
      end
    else
      dataset = value
    end
    @chart.datasets << dataset
  end

  def size string
    @chart.send :size=, string
  end
end
