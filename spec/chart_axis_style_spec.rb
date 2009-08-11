require File.dirname(__FILE__) + '/../spec_helper'

class TestChart < Chart; end

class TestChartWithAxisStyle < Chart
  include CommonParams::ChartAxisStyle
end

describe CommonParams::ChartAxisStyle do
  it 'adds :axis_types to the parameters hash for the base class' do
    TestChart.parameters.should_not include(:axis_types)
    TestChartWithAxisStyle.parameters.should include(:axis_types)
  end
end

describe CommonParams::ChartAxisStyle, '#axis_types' do
  it 'defines a reader for axes to the base class' do
    TestChart.new.respond_to?(:axes).should be_false
    TestChartWithAxisStyle.new.respond_to?(:axes).should be_true
  end

  it 'defines a writer for axes to the base class' do
    TestChart.new.respond_to?(:axes=).should be_false
    TestChartWithAxisStyle.new.respond_to?(:axes=).should be_true
  end

  it 'joins all axis types and prepends the proper code' do
    c = TestChartWithAxisStyle.new
    c.axes << Axis.new(:bottom, 'Test')
    c.axis_types.should match(/^chxt=x/)
  end
end

describe CommonParams::ChartAxisStyle, '#axis_labels' do
  it 'defines a reader for axis labels to the base class' do
    TestChart.new.respond_to?(:axis_labels).should be_false
    TestChartWithAxisStyle.new.respond_to?(:axis_labels).should be_true
  end

  it 'properly formats a single axis' do
    c = TestChartWithAxisStyle.new
    c.axes << Axis.new(:bottom, %w{ one two three })
    c.axis_labels.should == "chxl=0:|one|two|three"
  end

  it 'properly formats a multiple axes' do
    c = TestChartWithAxisStyle.new
    c.axes << Axis.new(:bottom, %w{ one two three })
    c.axes << Axis.new(:left,   %w{ A B C })
    c.axis_labels.should == 'chxl=0:|one|two|three|1:|A|B|C'
  end

end

describe CommonParams::ChartAxisStyle, '#initialize' do
  it 'default axes to []' do
    TestChartWithAxisStyle.new.axes.should == []
  end
end
