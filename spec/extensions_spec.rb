require File.dirname(__FILE__) + '/../spec_helper'

describe Object do
  it 'defines HTML_HEX_COLORS' do
    colors = %w{ aqua gray navy silver black green olive teal blue lime purple white fuchsia maroon red yellow }
    colors.each { |color| Object::HTML_HEX_COLORS.keys.should include(color) }
    Object::HTML_HEX_COLORS.keys.size.should == 16
  end

  it 'defines the colors as valid hex colors' do
    Object::HTML_HEX_COLORS.values.each { |color| color.should be_hex_color }
  end
end

describe Object, '#blank?' do
  it 'returns true if the object is nil' do
    nil.should be_nil
    nil.should be_blank
  end

  it 'returns true if the object is blank' do
    ''.should be_empty
    ''.should be_blank
  end

  it 'returns false if the object is not nil or blank' do
    'test'.should_not be_nil
    'test'.should_not be_empty
    'test'.should_not be_blank
  end
end

describe Object, '#to_hex_color' do
  before :all do
    @colors = %w{ aqua gray navy silver black green olive teal blue lime purple white fuchsia maroon red yellow }
  end

  it 'returns the string if it is a valid hex color' do
    '000000'.to_hex_color.should == '000000'
  end

  it 'returns the string if it is a valid hex color with opacity' do
    '000000FF'.to_hex_color.should == '000000FF'
  end

  it 'converts string color names to common hex colors' do
    @colors.each { |color| color.to_hex_color.should be_hex_color }
  end

  it 'converts symbol color names to common hex colors' do
    @colors.each { |color| color.to_sym.to_hex_color.should be_hex_color }
  end
end

describe Integer, '#simple_encode' do
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
    15.times { lambda { (rand(100) + 62).simple_encode}.should raise_error }
  end
end

describe Integer, '#extended_encode' do
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
    15.times { lambda { (rand(100) + 4096).extended_encode}.should raise_error }
  end
end

describe String, '#hex_color?' do
  it 'returns true if the string is a 6 character hex color' do
    '000000'.should be_hex_color
  end
  it 'returns false if the string is a 6 character hex color' do
    'not a color'.should_not be_hex_color
  end
end

describe String, '#hex_color_with_opacity?' do
  it 'returns true if the string is a 6 character hex color with a 2 digit hex opacity value' do
    '000000FF'.should be_hex_color_with_opacity
  end
  it 'returns false if the string is a 6 character hex color' do
    'not a color'.should_not be_hex_color_with_opacity
  end
end