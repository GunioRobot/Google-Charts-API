require File.dirname(__FILE__) + '/../spec_helper'

describe ChartMarker do
  it 'defines MARKER_TYPES' do
    types = %w{ arrow cross diamond circle square x partial_vertical_line vertical_line horizontal_line }
    types.each { |type| ChartMarker::MARKER_TYPES.keys.should include(type.to_sym) }
  end

  it 'defines PARAMETERS' do
    ChartMarker::PARAMETERS.should == [:type, :color, :index, :point, :size, :priority]
  end
end

describe ChartMarker, '#type' do
  it 'defaults to circle' do
    ChartMarker.new.type.should == ChartMarker::MARKER_TYPES[:circle]
  end

  it 'raises an error if an invalid type is specified' do
    c = Chart.new
    lambda { c.type = :invalid_marker_type }.should raise_error
  end

  it 'allows valid types' do
    m = ChartMarker.new
    types = %w{ arrow cross diamond circle square x partial_vertical_line vertical_line horizontal_line }
    types.each { |t| lambda { m.type = t.to_sym }.should_not raise_error }
  end

  it 'sets the type instance variable' do
    m = ChartMarker.new
    m.type = :arrow
    m.instance_variable_get('@type').should == ChartMarker::MARKER_TYPES[:arrow]
  end
end

describe ChartMarker, '#color' do
  it 'raises an error if color is not set' do
    lambda { ChartMarker.new.color }.should raise_error
  end

  it 'returns the proper hex color if set' do
    ChartMarker.new(:color => :red).color.should == 'FF0000'
  end
end

describe ChartMarker, '#index' do
  it 'raises an error if index is nil' do
    lambda { Chart.new.index }.should raise_error
  end
end

describe ChartMarker, '#point' do
  it 'defaults to -1' do
    ChartMarker.new.point.should == -1
  end

  it 'prepends @ to the type if the point format is x:y' do
    m = ChartMarker.new
    m.point = '4:5'
    m.type[0...1].should == '@'
  end
end

describe ChartMarker, '#size' do
  it 'raises an error if size is nil' do
    lambda { Chart.new.size }.should raise_error
  end
end

describe ChartMarker, '#to_s' do
  it 'takes a param that sets the index' do
    m = ChartMarker.new :size => 12, :color => :red
    m.to_s(12)
    m.index.should == 12
  end

  it 'gathers all parmeters and joins them with strings' do
    m = ChartMarker.new :size => 12, :color => :red
    m.to_s(0).should == "o,FF0000,0,-1,12"
  end
end
