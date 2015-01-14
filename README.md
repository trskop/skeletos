# Skeletos

[![Haskell Programming Language](https://img.shields.io/badge/language-Haskell-blue.svg)][Haskell.org]
[![BSD3 License](http://img.shields.io/badge/license-BSD3-brightgreen.svg)][tl;dr Legal: BSD3]


## Description

Create skeleton project, file or code snippet from a template.

> The skeleton (from Greek σκελετός, skeletos "dried up")is the body part that
> forms the supporting structure of an organism.
>
> > -- [Wikipedia: Skeleton][]


## Usage

    skeletos [-D VARIABLE[=[TYPE:]VALUE]] [-o FILE] QUERY

### Variable Definition

    VARIABLE[=[TYPE:]VALUE]

Where:

* `VARIABLE` is arbitrary string that doesn't contain `'='` character.

* `TYPE` is one of `text`, `bool`, `int` or `word`, if omitted, then it will
  try to guess. Gessing is done as follows:

  1. If `VALUE` is not a negative number, then it is considered a `word`; if
     it's negative, then it is an `int`.
  2. If it is `true` or `false` (case ignored) then it is considered a `bool`.
  3. If non above applies, then it is considered a `text`.

  It is possible to define boolean using numeric value, but then it is
  necessary to specify a type: `bool:0` (same as `bool:false`) or `bool:42`
  (same as `bool:true`).

* `VALUE` is arbitrary string that may be constricted by `TYPE`, if defined.
  `VALUE` is optional and if it's not present, then variable is defined with
  empty value.

Examples:

    module-name='Data.Foo'
    module-name='text:Data.Foo'
    use-tabs='bool:false'
    shift-width='word:2'

### Query

Query format:

    type={package|file|snippet} [language=STRING] [tag=STRING ...]


## Examples


### Create a Haskell Module

````sh
skeletos
    -Dmodule-name='Skeletos.Type.Foo' -Dauthor='John Smith' -Demail='em@il' \
    type=file language=haskell tag=module tag=normal \
    -o src/Skeletos/Type/Foo.hs
````


### Create Shell Function

````sh
skeletos -Dfunction-name='foo' type=snippet language=sh tag=function
```



[Haskell.org]:
  http://www.haskell.org
  "The Haskell Programming Language"
[tl;dr Legal: BSD3]:
  https://tldrlegal.com/license/bsd-3-clause-license-%28revised%29
  "BSD 3-Clause License (Revised)"
[Wikipedia: Skeleton]:
  https://en.wikipedia.org/wiki/Skeleton
  "Skeleton on Wikipedia"
