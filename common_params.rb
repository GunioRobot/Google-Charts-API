module CommonParams

  module ChartColors
    def self.included base
      base.parameters += [:colors]
    end

    def colors
      param_string :color, 'chco'
    end
  end

  module ChartDataScaling
    def self.included base
      base.send :attr_accessor, :use_scaling
      base.parameters += [:scaling]
    end

    def use_scaling?
      !!@use_scaling
    end

    def scaling
      param_string :scaling, 'chds' if use_scaling?
    end
  end

  module ChartLegend
    def self.included base
      base.parameters += [:legend]
    end

    def legend
      param_string :name, 'chdl', '|'
    end
  end

  module ChartMarkers
    def self.included base
      base.parameters += [:markers]
    end

    def update_markers
      @datasets.each_with_index do |d, i|
        d.markers.collect do |m|
          m.index = i
          m.color ||= d.color unless d.color.blank?
        end
      end
    end

    def markers
      update_markers
      param_string :marker_string, 'chm', '|'
    end
  end

  module ChartTitle
    def self.included base
      base.send :attr_writer, :title
      base.parameters += [:title]
    end

    def title
      "chtt=#{@title}" unless @title.blank?
    end
  end

  module ChartAxisStyle
    def self.included base
      base.send :attr_accessor, :axes
      base.parameters += [:axis_types, :axis_labels]
    end

    def initialize options = {}
      @axes ||= []
      super options
    end

    def axis_types
      "chxt=#{ @axes.collect(&:type).join(',')}" unless @axes.blank?
    end

    def axis_labels
      strings = []
      @axes.each_with_index { |axis, index| strings << axis.to_s(index) }
      "chxl=#{strings.join('|')}"
    end
  end
end
