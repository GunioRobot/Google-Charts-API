require File.dirname(__FILE__) + '/../spec_helper'

describe LineChart do
  it 'decends from Chart' do
    LineChart.ancestors.should include(Chart)
  end
end

describe LineChart, '#type=' do
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

describe LineChart, '#type' do
  it 'is the properly formatted chart type' do
    LineChart::LINE_CHART_TYPES.each do |symbol, string|
      LineChart.new(:type => symbol).type.should == "cht=#{string}"
    end
  end
end

describe LineChart, '#url' do
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

describe LineChart, '#build' do
  it 'returns a new dataset' do
    lc = LineChart.build {}
    lc.is_a?(LineChart).should be_true
  end

  it 'sets the chart title' do
    lc = LineChart.build 'title' do
    end
    lc.title.should == 'chtt=title'
  end

  it 'sets the chart size' do
    lc = LineChart.build do
      size '300x300'
    end
    lc.size.should == 'chs=300x300'
  end

  it 'adds datasets to the chart' do
    d = Dataset.build 'first' do 
      data [10,20,30,40,50]
      color :black
    end
    lc = LineChart.build do
      data d
    end
    lc.datasets.should include(d)
  end

  it 'adds axes to the chart' do
    lc = LineChart.build do
      axes :bottom
    end
    lc.axes.first.should == Axis.new(:bottom)
  end

  it 'adds axes with labels to the chart' do
    lc = LineChart.build do
      axes :bottom, :labels => %w{ one two three}
    end
    lc.axes.first.should == Axis.new(:bottom, :labels => %w{ one two three})
  end

  it 'adds axes with ranges to the chart' do
    lc = LineChart.build do
      axes :bottom, :range => {:start => 5, :end => 25}
    end
    lc.axes.first.should == Axis.new(:bottom, :range => {:start => 5, :end => 25})
  end
end
