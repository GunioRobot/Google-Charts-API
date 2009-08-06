module CommonParams

  module ChartColors
    def self.included(base);
      base.send :attr_accessor, :colors
    end
    # don't forget to add @colors = [] to your
    # initialize block when you include this
    
    #TODO: finish colors
  end

  module ChartTitle
    def self.included(base)
      base.send :attr_writer, :title
    end

    def title
      "chtt=#{@title}" unless @title.nil?
    end

  end
end
