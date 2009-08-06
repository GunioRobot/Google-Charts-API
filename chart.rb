class Chart
  BASE_URL = 'http://chart.apis.google.com/chart?'
  PARAMETERS = [ :encoded_data, :size, :title, :type ]

  attr_accessor :datasets

  def initialize options = {}
    # be sure to call super if you override this method in your child class
    options.each { |k,v| instance_variable_set "@#{k}", v }
    self.size = @size if @size
    @datasets = []
  end

  def url
    params = PARAMETERS.inject([]) do |all, this|
      value = send this
      all << value unless value.nil?
      all
    end

    BASE_URL + params.join('&')
  end

  def size
    "chs=#{@size}"
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
    e = encoding
    str = "chd=#{e.to_s[0...1]}:"
    str += @datasets.collect {|d| d.encoded_data encoding}.join '|'
  end

  def size= new_size
    width,height = new_size.split('x').map {|a| a.to_i}
    raise "Maximum size is 300,000 pixels" if height * width > 300_000
    raise "Maximum width is 1,000 pixels"  if width  > 1_000
    raise "Maximum height is 1,000 pixels" if height > 1_000
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
