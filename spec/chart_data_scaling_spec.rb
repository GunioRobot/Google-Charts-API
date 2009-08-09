require File.dirname(__FILE__) + '/../spec_helper'

class TestChart < Chart; end

class TestChartWithDataScaling < Chart
  include CommonParams::ChartDataScaling
end

describe CommonParams::ChartDataScaling do
  it 'adds :scaling to the parameters hash for the class' do
    TestChart.parameters.should_not include(:scaling)
    TestChartWithDataScaling.parameters.should include(:scaling)
  end
end

describe CommonParams::ChartDataScaling, '@use_scaling' do
  it 'adds an attr_accessor for @use_scaling' do
    TestChart.new.respond_to?(:use_scaling=).should be_false
    TestChart.new.respond_to?(:use_scaling).should  be_false

    TestChartWithDataScaling.new.respond_to?(:use_scaling=).should be_true
    TestChartWithDataScaling.new.respond_to?(:use_scaling).should  be_true
  end
end

describe CommonParams::ChartDataScaling, '#scaling' do
  it 'defines a reader for scaling to the base class' do
    TestChart.new.respond_to?(:scaling).should be_false
    TestChartWithDataScaling.new.respond_to?(:scaling).should be_true
  end

  it 'calls param string with the symbol and param name if @use_scaling is true' do
    c = TestChartWithDataScaling.new
    c.use_scaling = true
    c.should_receive(:param_string).with(:scaling, 'chds')
    c.scaling
  end
  
  it 'returns nil if @use_scaling is false' do
    c = TestChartWithDataScaling.new
    c.should_not_receive(:param_string).with(:scaling, 'chds')
    c.scaling.should == nil
  end
end
