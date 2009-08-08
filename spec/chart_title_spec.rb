require File.dirname(__FILE__) + '/../spec_helper'

class TestChart < Chart; end

class TestChartWithTitle < Chart
  include CommonParams::ChartTitle
end

describe CommonParams::ChartTitle do
  it 'adds an attr_writer for title to the base class' do
    TestChart.new.respond_to?(:title=).should be_false
    TestChartWithTitle.new.respond_to?(:title=).should be_true
  end

  it 'adds :colors to the parameters hash for the class' do
    TestChart.parameters.should_not      include(:title)
    TestChartWithTitle.parameters.should include(:title)
  end
end

describe CommonParams::ChartTitle, '#title' do
  it 'defines a reader for title to the base class' do
    TestChart.new.respond_to?(:title).should be_false
    TestChartWithTitle.new.respond_to?(:title).should be_true
  end

  it 'calls param string with the symbol and param name' do
    c = TestChartWithTitle.new :title => 'Test'
    c.title.should == 'chtt=Test'
  end
end
