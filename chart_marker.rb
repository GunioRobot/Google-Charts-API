class ChartMarker
  MARKER_TYPES = {
    :arrow   => 'a',    :cross   => 'c',    :diamond => 'd',
    :circle  => 'o',    :square  => 's',    :x       => 'x',

    :partial_vertical_line => 'v',
    :vertical_line         => 'V',
    :horizontal_line       => 'h'
  }

  PARAMETERS = [:type, :color, :index, :point, :size, :priority]

  attr_accessor :index, :priority
  attr_reader   :type
  attr_writer   :color, :size

  def initialize options = {}
    self.type = options.delete(:type) || :circle
    options.each { |k,v| instance_variable_set "@#{k}", v }
    @point ||= -1
  end

  def to_s index = nil
    self.index = index unless index.blank?
    check_values
    PARAMETERS.collect { |p| self.send(p) }.compact.join ','
  end

  def type= type
    MARKER_TYPES.include?(type) ? @type = MARKER_TYPES[type] : raise('Invalid Marker Type')
  end

  def color
    @color.to_hex_color if @color
  end

  def index
    @index
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

private

  def check_values
    params = %w{ color index point size }
    params.each do |p| 
      raise "#{p} must be specified" if instance_variable_get("@#{p}").blank?
    end
  end

end
