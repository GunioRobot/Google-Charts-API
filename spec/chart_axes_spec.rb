require File.dirname(__FILE__) + '/../spec_helper'

class TestChart < Chart; end

class TestChartWithAxes < Chart
  include CommonParams::ChartAxes
end

describe CommonParams::ChartAxes do
  it 'adds :axis_types to the parameters hash for the base class' do
    TestChart.parameters.should_not include(:axis_types)
    TestChartWithAxes.parameters.should include(:axis_types)
  end
end

describe CommonParams::ChartAxes, '#initialize' do
  it 'defaults axes to []' do
    TestChartWithAxes.new.axes.should == []
  end
end

describe CommonParams::ChartAxes, '#axis_types' do
  it 'defines a reader for axes to the base class' do
    TestChart.new.respond_to?(:axes).should be_false
    TestChartWithAxes.new.respond_to?(:axes).should be_true
  end

  it 'defines a writer for axes to the base class' do
    TestChart.new.respond_to?(:axes=).should be_false
    TestChartWithAxes.new.respond_to?(:axes=).should be_true
  end

  it 'joins all axis types and prepends the proper code' do
    c = TestChartWithAxes.new
    c.axes << Axis.new(:bottom, :labels => 'Test')
    c.axis_types.should match(/^chxt=x/)
  end
end

describe CommonParams::ChartAxes, '#axis_labels' do
  it 'defines a reader for axis labels to the base class' do
    TestChart.new.respond_to?(:axis_labels).should be_false
    TestChartWithAxes.new.respond_to?(:axis_labels).should be_true
  end

  it 'returns nil if there are no labels' do
    c = TestChartWithAxes.new
    c.axes << Axis.new(:bottom)
    c.axis_labels.should be_nil
  end

  it 'properly formats a single axis' do
    c = TestChartWithAxes.new
    c.axes << Axis.new(:bottom, :labels =>  %w{ one two three })
    c.axis_labels.should == "chxl=0:|one|two|three"
  end

  it 'properly formats a multiple axes' do
    c = TestChartWithAxes.new
    c.axes << Axis.new(:bottom, :labels => %w{ one two three })
    c.axes << Axis.new(:left,   :labels => %w{ A B C })
    c.axis_labels.should == 'chxl=0:|one|two|three|1:|A|B|C'
  end
end

describe CommonParams::ChartAxes, '#axis_ranges' do
  it 'defines a reader for axis ranges to the base class' do
    TestChart.new.respond_to?(:axis_ranges).should be_false
    TestChartWithAxes.new.respond_to?(:axis_ranges).should be_true
  end

  it 'returns nil if there are no ranges' do
    c = TestChartWithAxes.new
    c.axes << Axis.new(:bottom)
    c.axis_ranges.should be_nil
  end

  it 'properly formats a single axis' do
    c = TestChartWithAxes.new
    c.axes << Axis.new(:bottom, :range => {:start => 5, :end => 100 })
    c.axis_ranges.should == 'chxr=0,5,100'
  end

  it 'properly formats a multiple axes' do
    c = TestChartWithAxes.new
    c.axes << Axis.new(:bottom, :range => {:start => 5, :end => 100 })
    c.axes << Axis.new(:left,   :range => {:start => 25, :end => 50 })
    c.axis_ranges.should == 'chxr=0,5,100|1,25,50'
  end
end
