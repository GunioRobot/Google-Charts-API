require File.dirname(__FILE__) + '/../spec_helper'

class TestChart < Chart; end

class TestChartWithChartMarkers < Chart
  include CommonParams::ChartMarkers
end

describe CommonParams::ChartMarkers do
  it 'adds :markers to the parameters hash for the class' do
    TestChart.parameters.should_not include(:markers)
    TestChartWithChartMarkers.parameters.should include(:markers)
  end
end

describe CommonParams::ChartMarkers, '#colors' do
  it 'defines a reader for markers to the base class' do
    TestChart.new.respond_to?(:markers).should be_false
    TestChartWithChartMarkers.new.respond_to?(:markers).should be_true
  end

  it 'calls param string with the symbol and param name' do
    c = TestChartWithChartMarkers.new
    c.should_receive(:param_string).with(:marker_string, 'chm', '|')
    c.markers
  end
end
