A(nother) Google Charts API Wrapper
===================================

I wasn't really happy with the Google Charts API wrappers out there, and I wasn't making much progress
with the manual implementation I'd been working on. So here's how I think I'd want to use Google's API.

See [The Google Charts API](http://code.google.com/apis/chart/ "The Google Charts API") for more info.

Line Charts
-----------

Are what I need, so that's getting implemented first.

Create a line chart:

    lc = LineChart.new :title => 'Foo', :size => '100x100'
    lc.datasets << Dataset.new(:data => [5, 25, 50])
    lc.url # => http://chart.apis.google.com/chart?chd=s:FZy&chs=100x100&cht=lc&chtt=Foo


Or, use a Builder:

    lc = LineChart.build 'Foo' do
      size '100x100'
      data Dataset.new(:data => [5, 25, 50])
    end
    lc.url # => http://chart.apis.google.com/chart?chd=s:FZy&chs=100x100&cht=lc&chtt=Foo

![Example Chart](http://chart.apis.google.com/chart?chd=s:FZy&chs=100x100&cht=lc&chtt=Foo "Simple Line Chart")

Add data markers:

    d = Dataset.build 'Example with markers' do
      data [5, 25, 50]
      color :red
      marker ChartMarker.new(:size => 8)
    end

    lc = LineChart.build 'Foo' do
      size '300x200'
      data d
    end
![Example Chart](http://chart.apis.google.com/chart?chd=s:FZy&chs=300x200&cht=lc&chco=FF0000&chm=o,FF0000,0,-1,8&chdl=Example%20with%20markers&chtt=Foo "Example with Markers")

Add axis labels:

    lc = LineChart.build 'Test' do
      size '350x250'
      axes :bottom, %w{ one two three}
      axes :left,   %w{ A B C}

      data (Dataset.build 'First' do
        data  [15,5,35]
        color :red
        marker ChartMarker.new(:type => :circle, :size => 12)
      end)
    end

![Example Chart](http://chart.apis.google.com/chart?chd=s:PFj&chs=350x250&cht=lc&chco=FF0000&chdl=First&chtt=Test&chm=o,FF0000,0,-1,12&chxt=x,y&chxl=0:|one|two|three|1:|A|B|C "Example with Axis Labels")

Bar Charts
----------

Are similar enough to line charts that I've added some rudimentary support. This is **NOT** tested!

    bc = BarChart.new :title => 'Foo', :size => '100x100'
    bc.datasets << Dataset.new(:data => [5, 25, 50])

![Example Chart](http://chart.apis.google.com/chart?chd=s:FZy&chs=100x100&cht=bvg&chtt=Foo "Example Bar Chart")

There is no Bar Chart Builder (yet)

Spiffiness
----------

* Data encoding is handled automagically
* Multiple data sets are already supported
* Planning on (eventually) implementing the entire Charts API
