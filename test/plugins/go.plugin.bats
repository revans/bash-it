#!/usr/bin/env bats

##
# Travis notes:
#   - `which go`
#     - /home/travis/.gimme/versions/go1.7.4.linux.amd64/bin/go
#   - `go env GOROOT` & `$GOROOT`
#     - /home/travis/.gimme/versions/go1.7.4.linux.amd64
#   - `go env GOPATH` & `GOPATH`
#     - /home/travis/gopath
#

load ../test_helper
load ../../lib/helpers
load ../../lib/composure

@test 'ensure _go_pathmunge_wrap is defined' {
  load ../../plugins/available/go.plugin
  [[ $(type -t _go_pathmunge_wrap) = 'function' ]]
}

@test 'debug path in travis' {
  assert_equal $PATH 'dummy'
}

@test 'debug travis' {
  export GOROOT='/foo'
  export GOPATH='/bar'
  local OLD_PATH=$PATH

  load ../../plugins/available/go.plugin

  assert_equal $OLD_PATH $PATH
}

#@test 'plugins go: single entry in GOPATH' {
#  export GOROOT='/baz'
#  export GOPATH='/foo'
#  load ../../plugins/available/go.plugin
#  assert_equal $(cut -d':' -f1,2 <<<$PATH) '/foo/bin:/baz/bin'
#}
#
#@test 'plugins go: single entry in GOPATH, with space' {
#  export GOROOT="/baz"
#  export GOPATH="/foo bar"
#  load ../../plugins/available/go.plugin
#
#  echo "$(echo $PATH | cut -d':' -f1)"
#  [ "$(echo $PATH | cut -d':' -f1)" = "/foo bar/bin" ]
#
#  echo "$(echo $PATH | cut -d':' -f2)"
#  [ "$(echo $PATH | cut -d':' -f2)" = "/baz/bin" ]
#}
#
#@test 'plugins go: single entry in GOPATH, with escaped space' {
#  export GOROOT="/baz"
#  export GOPATH="/foo\ bar"
#  load ../../plugins/available/go.plugin
#
#  echo "$(echo $PATH | cut -d':' -f1)"
#  [ "$(echo $PATH | cut -d':' -f1)" = "/foo\ bar/bin" ]
#
#  echo "$(echo $PATH | cut -d':' -f2)"
#  [ "$(echo $PATH | cut -d':' -f2)" = "/baz/bin" ]
#}
#
#@test 'plugins go: multiple entries in GOPATH' {
#  export GOROOT="/baz"
#  export GOPATH="/foo:/bar"
#  load ../../plugins/available/go.plugin
#
#  echo "$(echo $PATH | cut -d':' -f1,2)"
#  [ "$(echo $PATH | cut -d':' -f1,2)" = "/foo/bin:/bar/bin" ]
#
#  echo "$(echo $PATH | cut -d':' -f3)"
#  [ "$(echo $PATH | cut -d':' -f3)" = "/baz/bin" ]
#}
#
#@test 'plugins go: multiple entries in GOPATH, with space' {
#  export GOROOT="/baz"
#  export GOPATH="/foo:/foo bar"
#  load ../../plugins/available/go.plugin
#
#  echo "$(echo $PATH | cut -d':' -f1,2)"
#  [ "$(echo $PATH | cut -d':' -f1,2)" = "/foo/bin:/foo bar/bin" ]
#
#  echo "$(echo $PATH | cut -d':' -f3)"
#  [ "$(echo $PATH | cut -d':' -f3)" = "/baz/bin" ]
#}
#
#@test 'plugins go: multiple entries in GOPATH, with escaped space' {
#  export GOROOT="/baz"
#  export GOPATH="/foo:/foo\ bar"
#  load ../../plugins/available/go.plugin
#
#  echo "$(echo $PATH | cut -d':' -f1,2)"
#  [ "$(echo $PATH | cut -d':' -f1,2)" = "/foo/bin:/foo\ bar/bin" ]
#
#  echo "$(echo $PATH | cut -d':' -f3)"
#  [ "$(echo $PATH | cut -d':' -f3)" = "/baz/bin" ]
#}
