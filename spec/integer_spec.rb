require File.dirname(__FILE__) + '/../spec_helper'

describe '#simple_encode' do
  it 'encodes values between 0 & 61 as a single character' do
    (0..61).each { |n| n.simple_encode.size.should == 1 }
  end

  it 'encodes values between 0 & 61 per the google character array' do
    (0..61).each { |n| n.simple_encode.should == Integer::CHARACTERS[n] }
  end

  it 'properly encodes the following arbitrary values' do
    values = { 0 => 'A', 12 => 'M', 24 => 'Y', 48 => 'w', 60 => '8' }

    values.each { |k,v| k.simple_encode.should == v }
  end

  it 'raises an exception when trying to encode negative numbers' do
    15.times { lambda { -(rand 100).simple_encode}.should raise_error }
  end

  it 'raises an exception when trying to encode numbers > 61' do
    15.times { lambda { (rand(100) + 61).simple_encode}.should raise_error }
  end
end

describe '#extended_encode' do
  it 'encodes values between 0 & 4095 as two characters' do
    (0..4095).each { |n| n.extended_encode.size.should == 2 }
  end

  it 'encodes values between 0 & 4095 per the google character array' do
    (0..4095).each { |n| n.extended_encode.should == "#{Integer::CHARACTERS[n / 64]}#{Integer::CHARACTERS[n % 64]}" }
  end

  it 'properly encodes the following arbitrary values' do
    values = {
      0    => 'AA', 1    => 'AB', 23   => 'AX', 456  => 'HI', 789  => 'MV',
      912  => 'OQ', 1000 => 'Po', 2450 => 'mS', 3905 => '9B', 4095 => '..'
    }

    values.each { |k,v| k.extended_encode.should == v }
  end

  it 'raises an exception when trying to encode negative numbers' do
    15.times { lambda { -(rand 100).extended_encode}.should raise_error }
  end

  it 'raises an exception when trying to encode numbers > 4095' do
    15.times { lambda { (rand(100) + 4095).extended_encode}.should raise_error }
  end
end
