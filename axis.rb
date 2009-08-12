class Axis
  AXIS_TYPES = { :top => 't', :right => 'r', :bottom => 'x', :left => 'y' }

  def initialize type, options = {}
    raise 'Type is required!' unless type
    raise 'Type is invalid!'  unless AXIS_TYPES.include?(type)

    @type   = AXIS_TYPES[type]
    self.labels = options.delete :labels
    self.range  = options.delete :range
  end

  def labels= value
    return if value.blank?
    @range  = nil
    @labels = value.is_a?(Array) ? value.join('|') : value.to_s
  end

  def range= options
    return nil if options.blank?
    raise 'A hash must be used to set axis range!' unless options.is_a? Hash
    raise 'Range must have a start value!' if options[:start].blank?
    raise 'Range must have an end value!'  if options[:end].blank?

    @labels = nil
    @range  = [ options[:start], options[:end], options[:interval] ].compact.join(',')
  end

  def labels index
    return nil if @labels.blank?
    "#{index}:|#{@labels}"
  end

  def range index
    return nil if @range.blank?
    "#{index},#{@range}"
  end

  def type
    @type
  end

  def == other_axis
    label_match = self.labels(0) == other_axis.labels(0)
    range_match = self.range(0)  == other_axis.range(0)
    type_match  = self.type      == other_axis.type

    type_match && label_match && range_match
  end
end
