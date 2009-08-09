require File.dirname(__FILE__) + '/../spec_helper'

describe Dataset do
  it 'accepts an optional name' do
    d = Dataset.new :data => [0], :name => 'Foo'
    d.name.should == 'Foo'
  end
end

describe 'data' do
  it 'complains if data is nil' do
    lambda { Dataset.new.data }.should raise_error
  end

  it 'complains if data is 0 length' do
    lambda { Dataset.new(:data => '').data }.should raise_error
  end

  it 'complains if data is not an array' do
    lambda { Dataset.new(:data => 'foo').data }.should raise_error
  end

  it 'outputs unencoded data' do
    d = Dataset.new :data => [0, 1, 2]
    d.data.should == [0, 1, 2]
  end
end

describe '#encoded_data' do
  it 'defaults to text encoding' do
    Dataset.new(:data => [0, 1, 2]).encoded_data.should == '0,1,2'
  end

  it 'supports text encoding' do
    Dataset.new(:data => [0, 1, 2]).encoded_data(:text).should == '0,1,2'
  end

  it 'supports simple encoding' do
    Dataset.new(:data => [0, 1, 2]).encoded_data(:simple_encode).should == 'ABC'
  end

  it 'supports extended encoding' do
    Dataset.new(:data => [0, 1, 2]).encoded_data(:extended_encode).should == 'AAABAC'
  end

  it 'raises an error for unsupported encodings' do
    d = Dataset.new :data => [0, 1, 2]
    lambda { d.encoded_data :invalid_data_encoding }.should raise_error
  end
end

describe '#marker_string' do
  before :all do
    @dataset = Dataset.new(:data => [0])
    @dataset.markers << ChartMarker.new
    @dataset.markers << ChartMarker.new
  end

  it 'passes an index to the marker(s)' do
    @dataset.markers.each {|m| m.should_receive(:to_s).with(5) }
    @dataset.marker_string 5
  end

  it 'returns nil if there are no markers' do
    Dataset.new(:data => [0]).marker_string(0).should be_nil
  end

  it 'collects the markers' do
    @dataset.markers.should_receive(:collect)
    @dataset.marker_string 0
  end
end
