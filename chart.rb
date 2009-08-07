class Chart
  BASE_URL   = 'http://chart.apis.google.com/chart?'
  PARAMETERS = [ :encoded_data, :size, :type ]

  class << self
    attr_accessor :parameters
  end

  def self.parameters
    @parameters || PARAMETERS
  end

  attr_accessor :datasets

  def initialize options = {}
    # be sure to call super if you override this method in your child class
    self.size = options.delete :size
    @datasets = []
    options.each { |k,v| instance_variable_set "@#{k}", v }
  end

  def url
    params = self.class.parameters.inject([]) do |all, this|
      value = send this
      all << value unless value.blank?
      all
    end

    BASE_URL + params.join('&')
  end

  def size
    @size.blank? ? raise('Size not set!') : "chs=#{@size}"
  end

  def type; raise 'Override this method in your child class!' end

protected

  def values
    @datasets.collect { |d| d.data }.flatten.uniq
  end

  def max; values.max end
  def min; values.min end

private

  def encoded_data
    raise 'No data!' if @datasets.empty?
    e = encoding

    separator = e == :text ? '|' : ','
    
    str = "chd=#{e.to_s[0...1]}:"
    str += @datasets.collect { |d| d.encoded_data e }.join separator
  end

  def size= new_size
    if new_size
      width, height = new_size.split('x').map {|a| a.to_i}
      raise "Maximum size is 300,000 pixels" if height * width > 300_000
      raise "Maximum width is 1,000 pixels"  if width  > 1_000
      raise "Maximum height is 1,000 pixels" if height > 1_000
    end
    @size = new_size
  end

  def non_integer_data?
    ! values.reject { |n| n.is_a? Integer }.empty?
  end

  def encoding
    return :text if 0   > min
    return :text if max > 4095
    return :text if non_integer_data?

    max > 61 ? :extended_encode : :simple_encode
  end
end
