#!/usr/bin/env bats

@test "ruby is available on the PATH" {
  run which ruby
  [ "$status" -eq 0 ]
}

@test "ruby is the right version" {
  run ruby -v
  # keep matched with default attribute value for `node[:ruby_version]`
  RUBY_REGEX='^ruby 2.3.1*'
  [[ "$output" =~ $RUBY_REGEX ]]
}
