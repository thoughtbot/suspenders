Compress HTTP requests at the Rails layer.

This uses `Rack::Deflater`, and is done at the app layer instead of at the Web
server layer.
