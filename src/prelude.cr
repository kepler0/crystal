require "intrinsics"
require "libc"
ifdef windows
  require "win32"
end
require "macros"
require "object"
require "reference"
require "exception"
require "value"
require "struct"
require "proc"
require "thread"
require "gc"
# require "gc/null"
require "gc/boehm"
require "class"
require "comparable"
require "enumerable"
require "iterator"
require "nil"
require "bool"
require "char"
require "number"
require "int"
require "float"
require "pointer"
require "slice"
require "range"
require "char_reader"
require "string"
require "symbol"
require "enum"
require "static_array"
require "array"
require "hash"
require "set"
require "tuple"
require "box"
require "math/math"
require "process"
require "io"
require "argv"
require "env"
require "file"
require "dir"
require "time"
require "random"
require "regex"
require "raise"
require "errno"
require "main"
require "concurrent"

def loop
  while true
    yield
  end
end
