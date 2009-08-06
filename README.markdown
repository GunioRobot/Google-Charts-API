A(nother) Google Charts API Wrapper
===================================

I wasn't really happy with the Google Charts API wrappers out there, and I wasn't making much progress
with the manual implementation I'd been working on. So here's how I think I'd want to use Google's API.

See [The Google Charts API](http://code.google.com/apis/chart/ "The Google Charts API") for more info.

Line Charts
-----------

Are what I need, so that's getting implemented first.

`lc = LineChart.new :title => 'Foo', :size => '600x300'
lc.datasets << Dataset.new(:data => [1,2,3,4,5])
lc.url # => http://chart.apis.google.com/chart?chd=s:BCDEF&chs=600x300&chtt=Foo&cht=lc`
Spiffiness
----------

* Data encoding is handled automagically
* Multiple data sets are already supported
* Planning on (eventually) implementing the entire Charts API

