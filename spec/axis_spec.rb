require File.dirname(__FILE__) + '/../spec_helper'

describe Axis do
  it 'defines AXIS TYPES as hash of valid axis types' do
    types = %w{ top right bottom left }
    types.each { |type| Axis::AXIS_TYPES.should include(type.to_sym) }
  end

  it 'requires type to be set' do
    lambda { Axis.new(nil) }.should raise_error('Type is required!')
  end

  it 'requires type to be valid' do
    lambda { Axis.new(:foo) }.should raise_error('Type is invalid!')
  end

  it 'sets @type' do
    axis = Axis.new :top
    axis.instance_variable_get("@type").should == Axis::AXIS_TYPES[:top]
  end

  it 'takes optional labels' do
    axis = Axis.new :bottom, :labels => ['One']
    axis.instance_variable_get('@labels').should include('One')
  end
end

describe Axis, '#range=' do
  before do
    @axis = Axis.new :bottom, :labels=> 'should be deleted', :range => {:start => 1, :end => 5 }
  end

  it 'returns nil if nothing is passed to range=' do
    (@axis.range=()).should be_nil
  end

  it 'resets axis labels' do
    @axis.instance_variable_get('@labels').should be_nil
  end

  it 'errors if range is not a hash' do
    lambda { @axis.range = 'invalid' }.should raise_error('A hash must be used to set axis range!')
  end

  it 'errors if a start value is not set' do
    lambda { @axis.range = {:foo => 'bar'} }.should raise_error('Range must have a start value!')
  end

  it 'errors if an end value is not set' do
    lambda { @axis.range = {:start => 'bar'} }.should raise_error('Range must have an end value!')
  end
end

describe Axis, '#range' do
  it 'requires an index' do
    lambda { Axis.new(:bottom).range }.should raise_error
    lambda { Axis.new(:bottom).range(0)}.should_not raise_error
  end

  it 'returns nil if there is no range' do
    Axis.new(:bottom).range(0).should be_nil
  end

  it 'returns a string in the proper format (without interval)' do
    axis = Axis.new :bottom, :labels=> 'should be deleted', :range => {:start => 1, :end => 5}
    index = 0
    axis.range(index).should == "#{index},1,5"
  end
end

describe Axis, '#labels' do
  it 'resets axis range if specified after a range has been set' do
    axis = Axis.new :bottom, :range => {:start => 1, :end => 5}
    axis.labels = ['One']
    axis.instance_variable_get('@range').should be_nil
  end

  it 'is overridden by range if both are set in the constructor' do
    axis = Axis.new :bottom, :labels => ['One'], :range => {:start => 1, :end => 5}
    axis.instance_variable_get('@labels').should be_nil
    axis.instance_variable_get('@range').should_not be_nil
  end
end

describe Axis, '#labels' do
  it 'requires an index' do
    lambda { Axis.new(:bottom).labels }.should raise_error
    lambda { Axis.new(:bottom).labels(0)}.should_not raise_error
  end

  it 'returns nil if there are no labels' do
    Axis.new(:bottom).labels(0).should be_nil
  end

  it 'returns the encoded type' do
    axis = Axis.new :bottom, :labels => ['One']
    axis.labels(0).should match(/^0:\|/)
  end

  it 'if one label is specified it is appended to the string' do
    axis = Axis.new :bottom, :labels => ['One']
    axis.labels(0).should match(/One$/)
  end

  it 'if several labels are specified they are appended to the string, seperated by pipes' do
    axis = Axis.new :bottom, :labels => ['One', 'Two']
    axis.labels(0).should match(/One\|Two$/)
  end
end
