class ChartMarker
  MARKER_TYPES = {
    :arrow   => 'a',    :cross   => 'c',    :diamond => 'd',
    :circle  => 'o',    :square  => 's',    :x       => 'x',

    :partial_vertical_line => 'v',
    :vertical_line         => 'V',
    :horizontal_line       => 'h'
  }

  PARAMETERS = [:type, :color, :index, :point, :size, :priority]

  attr_accessor :priority
  attr_reader   :type
  attr_writer   :color, :index, :size

  def initialize options = {}
    self.type = options.delete(:type) || :circle
    options.each { |k,v| instance_variable_set "@#{k}", v }
    @point ||= -1
  end

  def to_s index
    self.index = index
    PARAMETERS.collect { |p| self.send(p) }.compact.join ','
  end

  def type= type
    MARKER_TYPES.include?(type) ? @type = MARKER_TYPES[type] : raise('Invalid Marker Type')
  end

  def color
    @color.blank? ? raise('Color must be specified') : @color.to_hex_color
  end

  def index
    @index.blank? ? raise('Index must be specified') : @index
  end

  def point= point
    @type = "@#{@type}" if point =~ /^\d+:\d+$/
    @point = point
  end

  def point
    @point.blank? ? raise('Point must be specified') : @point
  end

  def size
    @size.blank? ? raise('Size must be specified') : @size
  end
end
