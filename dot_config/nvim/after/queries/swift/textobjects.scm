;; extends

; Conditionals. Keep the outer capture separate so an if/else with multiple
; statement bodies produces only one outer range.
([
  (if_statement)
  (guard_statement)
  (switch_statement)
] @conditional.outer)

(if_statement
  (statements) @conditional.inner)

(guard_statement
  (statements) @conditional.inner)

(switch_statement
  (switch_entry) @conditional.inner)

; Loops
[
  (for_statement)
  (while_statement)
  (repeat_while_statement)
] @loop.outer

[
  (for_statement
    (statements) @loop.inner)
  (while_statement
    (statements) @loop.inner)
  (repeat_while_statement
    (statements) @loop.inner)
]
