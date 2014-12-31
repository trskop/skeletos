# Skeletos

[![Haskell Programming Language](https://img.shields.io/badge/language-Haskell-blue.svg)][Haskell.org]
[![BSD3 License](http://img.shields.io/badge/license-BSD3-brightgreen.svg)][tl;dr Legal: BSD3]


## Description

Create skeleton project, file or code snippet from a template.


## Usage

````
skeletos {project|file|snippet} [OPTIONS] [--] QUERY
````


## Examples


### Create Shell Function

````
skeletos snippet -Dfunction-name='foo' language=sh tag=function
```

````Shell
# TODO: Description
#
# Usage:
#
#   foo [OPTIONS]
function foo()
{
    :
}
````



[Haskell.org]:
  http://www.haskell.org
  "The Haskell Programming Language"
[tl;dr Legal: BSD3]:
  https://tldrlegal.com/license/bsd-3-clause-license-%28revised%29
  "BSD 3-Clause License (Revised)"
