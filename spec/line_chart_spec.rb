require File.dirname(__FILE__) + '/../spec_helper'

describe LineChart do
  it 'decends from Chart' do
    LineChart.ancestors.should include(Chart)
  end
end

describe '#type=' do
  it 'errors if an invalid type is specified' do
    lc = LineChart.new
    lambda { lc.type= :test }.should raise_error
  end

  it 'allows valid types' do
    lc = LineChart.new
    lambda { lc.type= :line_chart }.should_not raise_error
    lambda { lc.type= :sparkline  }.should_not raise_error
    lambda { lc.type= :scatter    }.should_not raise_error
  end

  it 'sets the instance variable type' do
    LineChart::LINE_CHART_TYPES.each do |symbol, string|
      LineChart.new(:type => symbol).instance_variable_get("@type").should == string
    end
  end
end

describe '#type' do
  it 'is the properly formatted chart type' do
    LineChart::LINE_CHART_TYPES.each do |symbol, string|
      LineChart.new(:type => symbol).type.should == "cht=#{string}"
    end
  end
end

describe '#url' do
  it 'includes the base url' do
    lc = LineChart.new :size => '600x300'
    lc.datasets << Dataset.new(:data => [10, 20, 30])
    lc.url.should include(Chart::BASE_URL)
  end

  it 'appends each parameter to the url string, and seperates with &' do
    lc = LineChart.new :size => '600x300'
    lc.datasets << Dataset.new(:data => [10, 20, 30])

    LineChart.parameters.each do |param|
      value = lc.send(param)
      lc.url.should include(value) unless value.blank?
    end
  end
end