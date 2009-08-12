class ChartBuilder
  attr_reader :chart

  def initialize
    raise 'Override this method in your builder!'
  end

  def dataset value, &block
    if block_given?
      dataset = Dataset.build value do
        instance_eval(&block)
      end
    else
      dataset = value
    end
    @chart.datasets << dataset
  end

  def size string
    @chart.send :size=, string
  end
end
