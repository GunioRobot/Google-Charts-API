require File.dirname(__FILE__) + '/../spec_helper'

describe Chart do
  it 'defines BASE_URL' do
    Chart::BASE_URL.should == 'http://chart.apis.google.com/chart?'
  end

  it 'defines PARAMETERS' do
    Chart::PARAMETERS.should include(:encoded_data, :size, :type)
  end

  it 'responds to type' do
    Chart.new.respond_to?(:type).should be_true
  end

  it 'errors unless type is overridden' do
    lambda { Chart.new.type }.should raise_error
  end
end

describe Chart, 'size' do
  it 'complains if the size is too big' do
    lambda { Chart.new(:size => '150x1500').size }.should raise_error
    lambda { Chart.new(:size => '1500x100').size }.should raise_error
    lambda { Chart.new(:size => '1000x500').size }.should raise_error
  end

  it 'allows valid sizes' do
    lambda { Chart.new(:size => '150x150').size }.should_not  raise_error
    lambda { Chart.new(:size => '500x500').size }.should_not  raise_error
    lambda { Chart.new(:size => '1000x300').size }.should_not raise_error
  end
end

describe Chart, '#datasets' do
  it 'is an array of datasets for this chart' do
    chart = Chart.new   :size => '600x300'
    data  = Dataset.new :data => [1,2,3]
    chart.datasets << data

    chart.datasets.should include(data)
  end
end

describe Chart, '#values' do
  it 'collects all of the datasets data' do
    chart = Chart.new
    chart.datasets << Dataset.new(:data => [1,2,3])
    chart.datasets << Dataset.new(:data => [40,50,60])

    chart.datasets.collect {|d| d.should_receive(:data) }
    chart.send :values
  end

  it 'returns an array of unique values' do
    chart = Chart.new
    chart.datasets << Dataset.new(:data => [1,2,3, 50])
    chart.datasets << Dataset.new(:data => [40,50,60])

    chart.send(:values).size.should == 6
  end

  it 'the array contains all of the data values' do
    chart = Chart.new
    chart.datasets << Dataset.new(:data => [1,2,3, 50])
    chart.datasets << Dataset.new(:data => [40,50,60])

    [1,2,3,40,50,60].each { |n| chart.send(:values).should include(n) }
  end

  describe '#max' do
    it 'returns the largest value' do
      chart = Chart.new
      chart.datasets << Dataset.new(:data => [1,2,3, 50])
      chart.datasets << Dataset.new(:data => [40,50,60])

      chart.send(:max).should == 60
    end
  end

  describe '#min' do
    it 'returns the smallest value' do
      chart = Chart.new
      chart.datasets << Dataset.new(:data => [1,2,3, 50])
      chart.datasets << Dataset.new(:data => [40,50,60])

      chart.send(:min).should == 1
    end
  end
end

describe Chart, '#non_integer_data' do
  it 'returns true if all the values are not integers' do
    chart = Chart.new
    chart.datasets << Dataset.new(:data => [-1.0,2,3])
    chart.should be_non_integer_data
  end

  it 'returns false if all the values are integers' do
    chart = Chart.new
    chart.datasets << Dataset.new(:data => [-1,2,3])
    chart.should_not be_non_integer_data
  end
end

describe Chart, '#encoding' do
  it 'chooses text encoding if the data contains negative numbers' do
    chart = Chart.new
    chart.datasets << Dataset.new(:data => [-1,2,3])
    chart.datasets << Dataset.new(:data => [40,50,60])
    chart.send(:encoding).should == :text
  end

  it 'chooses text encoding if the max value is > 4065' do
    chart = Chart.new
    chart.datasets << Dataset.new(:data => [-1,2,3])
    chart.datasets << Dataset.new(:data => [40,50,6000])
    chart.send(:encoding).should == :text
  end

  it 'chooses text encoding if the data contains floats' do
    chart = Chart.new
    chart.datasets << Dataset.new(:data => [-1,2,3])
    chart.datasets << Dataset.new(:data => [40,50,60.0])
    chart.send(:encoding).should == :text
  end

  it 'chooses simple encoding if all data is in the range 0..61' do
    chart = Chart.new   :size => '600x300'
    chart.datasets << Dataset.new(:data => [1,2,3])
    chart.datasets << Dataset.new(:data => [40,50,60])
    chart.send(:encoding).should == :simple_encode
  end

  it 'chooses extended encoding if all data is in the range 0..4095' do
    chart = Chart.new   :size => '600x300'
    chart.datasets << Dataset.new(:data => [40,50,60])
    chart.datasets << Dataset.new(:data => [100,200,300])
    chart.send(:encoding).should == :extended_encode
  end
end

describe Chart, '#encoded_data' do
  it 'collects all of the datasets data' do
    chart = Chart.new
    chart.datasets << Dataset.new(:data => [1,2,3])
    chart.datasets << Dataset.new(:data => [40,50,60])

    e = chart.send :encoding
    chart.datasets.collect { |d| d.should_receive(:encoded_data).with(e) }
    chart.send :encoded_data
  end

  it 'contains the proper prefix header for extended datasets' do
    chart = Chart.new
    chart.datasets << Dataset.new(:data => [100,200,300])
    chart.send(:encoded_data).should include('chd=e:')
  end

  it 'contains the proper prefix for simple datasets' do
    chart = Chart.new
    chart.datasets << Dataset.new(:data => [1,2,3])
    chart.send(:encoded_data).should include('chd=s:')
  end

  it 'contains the proper prefix for text datasets' do
    chart = Chart.new
    chart.datasets << Dataset.new(:data => [-1,-2,-3])
    chart.send(:encoded_data).should include('chd=t:')
  end

  describe 'Multiple datasets' do
    it 'seperates multiple extended-encoded datasets by commas' do
      chart = Chart.new
      chart.datasets << Dataset.new(:data => [100,200,300])
      chart.datasets << Dataset.new(:data => [400,500,600])
      chart.send(:encoded_data).should == "chd=e:BkDIEs,GQH0JY"
    end

    it 'seperates multiple simple-encoded datasets by commas' do
      chart = Chart.new
      chart.datasets << Dataset.new(:data => [1,2,3])
      chart.datasets << Dataset.new(:data => [4,5,6])
      chart.send(:encoded_data).should == "chd=s:BCD,EFG"
    end

    it 'seperates multiple text-encoded datasets by pipes' do
      chart = Chart.new
      chart.datasets << Dataset.new(:data => [-1,2,300])
      chart.datasets << Dataset.new(:data => [4,-5,60.2])
      chart.send(:encoded_data).should == "chd=t:-1,2,300|4,-5,60.2"
    end
  end
end

describe Chart, '#gather' do
  before :all do
    @chart = Chart.new
    @chart.datasets << Dataset.new(:data => [15,20,35], :color => :black)
    @chart.datasets << Dataset.new(:data => [10,25,30], :color => :red)
  end

  it 'returns nil if there are no datasets' do
    Chart.new.gather :color
  end

  it 'collects all of the specified info from the datasets' do
    @chart.datasets.should_receive(:collect).and_return([])
    @chart.gather :color
  end

  it 'calls the specified method on each dataset' do
    d = @chart.datasets.first
    d.should_receive :color
    @chart.gather :color
  end

  it 'joins the results together with the specified separator' do
    @chart.gather(:color, '\n').should == '000000\nFF0000'
  end

  it 'defaults to comma separated' do
    @chart.gather(:color).should == '000000,FF0000'
  end
end
