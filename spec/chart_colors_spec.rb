require File.dirname(__FILE__) + '/../spec_helper'

class TestChart < Chart; end

class TestChartWithColors < Chart
  include CommonParams::ChartColors
end

describe CommonParams::ChartColors do
  it 'adds :colors to the parameters hash for the class' do
    TestChart.parameters.should_not include(:colors)
    TestChartWithColors.parameters.should include(:colors)
  end
end

describe CommonParams::ChartColors, '#colors' do
  it 'defines a reader for colors to the base class' do
    TestChart.new.respond_to?(:colors).should be_false
    TestChartWithColors.new.respond_to?(:colors).should be_true
  end

  it 'calls param string with the symbol and param name' do
    c = TestChartWithColors.new
    c.should_receive(:param_string).with(:color, 'chco')
    c.colors
  end
end
