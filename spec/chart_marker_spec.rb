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
  it 'returns the proper hex color if set' do
    ChartMarker.new(:color => :red).color.should == 'FF0000'
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

describe ChartMarker, '#to_s' do
  before :all do
    @marker = ChartMarker.new :size => 12, :color => :red
  end
  it 'takes a param that sets the index' do
    @marker.to_s(12)
    @marker.index.should == 12
  end

  it 'calls check_values' do
    @marker.should_receive(:check_values)
    @marker.to_s(12)
  end

  it 'gathers all parmeters and joins them with strings' do
    @marker = ChartMarker.new :size => 12, :color => :red
    @marker.to_s(0).should == "o,FF0000,0,-1,12"
  end
end


describe ChartMarker, '#check_values' do
  it 'raises an error if color is not set' do
    m = ChartMarker.new
    m.color = nil
    lambda { m.send :check_values }.should raise_error('color must be specified')
  end

  it 'raises an error if index is nil' do
    m = ChartMarker.new :color => :red
    lambda { m.send :check_values }.should raise_error('index must be specified')
  end

  it 'raises an error if size is nil' do
    m = ChartMarker.new :color => :red, :index => 0
    lambda { m.send :check_values }.should raise_error('size must be specified')
  end
end
