class LineChartBuilder < ChartBuilder
  def initialize options = {}
    @chart = LineChart.new :title => options[:title]
  end
end
