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
    axis = Axis.new :bottom, ['One']
    axis.labels.should include('One')
  end
end

describe Axis, '#to_s' do
  it 'returns the encoded type' do
    axis = Axis.new :bottom, ['One']
    axis.to_s(0).should match(/^0:\|/)
  end

  it 'if one label is specified it is appended to the string' do
    axis = Axis.new :bottom, ['One']
    axis.to_s(0).should match(/One$/)
  end

  it 'if several labels are specified they are appended to the string, seperated by pipes' do
    axis = Axis.new :bottom, ['One', 'Two']
    axis.to_s(0).should match(/One\|Two$/)
  end
end
