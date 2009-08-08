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
