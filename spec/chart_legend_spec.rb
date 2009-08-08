require File.dirname(__FILE__) + '/../spec_helper'

class TestChart < Chart; end

class TestChartWithLegend < Chart
  include CommonParams::ChartLegend
end

describe CommonParams::ChartLegend do
  it 'adds :legend to the parameters hash for the class' do
    TestChart.parameters.should_not include(:legend)
    TestChartWithLegend.parameters.should include(:legend)
  end
end

describe CommonParams::ChartLegend, '#colors' do
  it 'defines a reader for colors to the base class' do
    TestChart.new.respond_to?(:legend).should be_false
    TestChartWithLegend.new.respond_to?(:legend).should be_true
  end

  it 'calls param string with the symbol and param name' do
    c = TestChartWithLegend.new
    c.should_receive(:param_string).with(:name, 'chdl', '|')
    c.legend
  end
end
