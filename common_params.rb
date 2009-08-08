module CommonParams

  module ChartColors
    def self.included base
      base.parameters += [:colors]
    end

    def colors
      param_string :color, 'chco'
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

    def set_marker_indicies
      @datasets.each_with_index { |d, i| d.markers.collect { |m| m.index = i } }
    end

    def markers
      set_marker_indicies
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

end
