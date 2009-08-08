require File.dirname(__FILE__) + '/../spec_helper'

class TestChart < Chart; end

class TestChartWithShapeMarkers < Chart
  include CommonParams::ChartShapeMarkers
end

describe CommonParams::ChartShapeMarkers do
  it 'adds :legend to the parameters hash for the class' do
    TestChart.parameters.should_not include(:shapes)
    TestChartWithShapeMarkers.parameters.should include(:shapes)
  end
end

describe CommonParams::ChartShapeMarkers, '#colors' do
  it 'defines a reader for colors to the base class' do
    TestChart.new.respond_to?(:shapes).should be_false
    TestChartWithShapeMarkers.new.respond_to?(:shapes).should be_true
  end

  it 'calls param string with the symbol and param name' do
    pending
    c = TestChartWithShapeMarkers.new
    c.should_receive(:param_string).with(:shapes, 'chm', '|')
    c.shapes
  end
end
