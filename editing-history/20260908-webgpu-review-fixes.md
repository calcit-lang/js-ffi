# WebGPU post-merge review fixes

- Make rejection text conversion total: null-prototype values and throwing
  toString implementations deliver WebGPU.error-unprintable to failed!.
- Release the recipe buffer when its size decoder or getter throws, then raise
  the documented stable failed-to-read-size error. Cleanup failures propagate.
- Run the recipe before destroying its device; the test double now rejects
  allocation after destruction instead of silently returning a usable buffer.

Regression tests exercise both unprintable rejection shapes, exactly one failure
callback, both size failure paths and exactly one release, and post-destroy use.
No public schema, dependency, release version, or unsafe budget changes.
