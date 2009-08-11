class Axis
  AXIS_TYPES = { :top => 't', :right => 'r', :bottom => 'x', :left => 'y' }

  attr_accessor :labels

  def initialize type, labels = []
    raise 'Type is required!' unless type
    raise 'Type is invalid!'  unless AXIS_TYPES.include?(type)

    @type   = AXIS_TYPES[type]
    @labels = ([] << labels).flatten
  end

  def type
    @type
  end

  def to_s index
    "#{index}:|#{@labels.join('|')}"
  end
end
