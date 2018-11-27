# Elysium

## Overview

Elysium is a chat application for people who want to share more.

A web app that uses [AngularDart](https://webdev.dartlang.org/angular) and
[AngularDart Components](https://webdev.dartlang.org/components).

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

## Set up

Install Dart by following instructions at
https://webdev.dartlang.org/guides/get-started#2-install-dart.

### Avoiding compile error

To avoid compile error `Target of URI doesn't exist: 'io_none.dart'.`, git
clone time_machine and resource. Make time_machine depend directly on the
clone. Then in the clone add the following comment:
`// ignore: URI_DOES_NOT_EXIST`. Read more at
https://github.com/Dana-Ferguson/time_machine/issues/9.

Run the chat by running `webdev serve`.

# Run tests

```
pub run build_runner test --fail-on-severe -- -p chrome
```

Or run `webdev serve` and open http://localhost:8081 in your browser.
