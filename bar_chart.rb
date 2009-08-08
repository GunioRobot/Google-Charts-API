class BarChart < Chart
  BAR_CHART_TYPES = {
    :horizontal_grouped => 'bhg', :horizontal_stacked => 'bhs',
    :vertical_grouped   => 'bvg', :vertical_stacked   => 'bvs'
  }

  include CommonParams::ChartColors
  include CommonParams::ChartLegend
  include CommonParams::ChartTitle

  def initialize options = {}
    self.type = options.delete(:type) || :vertical_grouped
    super
  end

  def type= type
    raise 'Invalid Chart Type' unless BAR_CHART_TYPES.include?(type)
    @type = BAR_CHART_TYPES[type]
  end
end
