require File.dirname(__FILE__) + '/../spec_helper'

describe Dataset do
  it 'accepts an optional title' do
    d = Dataset.new :data => [0], :title => 'Foo'
    d.title.should == 'Foo'
  end
end

describe 'data=' do
  it 'complains if data is nil' do
    lambda { Dataset.new }.should raise_error
  end

  it 'complains if data is 0 length' do
    lambda { Dataset.new :data => '' }.should raise_error
  end

  it 'complains if data is not an array' do
    lambda { Dataset.new :data => 'foo' }.should raise_error
  end

  it 'accepts an array of data' do
    lambda { Dataset.new :data => [1,2,3] }.should_not raise_error
  end
end

describe 'data' do
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
