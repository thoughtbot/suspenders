Show runtime profiling for your Rails app as you develop it.

This uses the `rack-mini-profiler` gem to show a speed badge on every page.
This is controlled by the `RACK_MINI_PROFILER` environment variable which
defaults to `0` in the `.sample.env`. Set it to `1` to enable profiling.

Updates your README.md to explain this environment variable.
