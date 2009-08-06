class Dataset
  attr_accessor :data, :title

  def initialize options = {}
    self.data = options[:data] || options['data']
    options.each { |k,v| instance_variable_set "@#{k}", v }
  end

  def data= data
    raise "Data should not be empty" if data.nil? || data.size == 0
    raise "Data should be an array"  unless data.is_a? Array
    @data = data
  end

  def data
    @data
  end

  def encoded_data encoding = :text
    return @data.join(',') if encoding == :text
    @data.map { |n| n.nil? ? '_' : n.send(encoding) }.join('')
  end

private

  def encode m
  end
end
