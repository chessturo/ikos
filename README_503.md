Run these in the root of this repo to build:
```
cmake -S . -B build -DCMAKE_INSTALL_PREFIX=$PWD/build/install -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
pushd build && cmake --build . && make install && popd
```

Then, `build/install/bin/ikos` is the created ikos executable.

Because `ikos` produces a database file in the directory where it's run, I
recommend running the tests from `test-503/`, e.g.,
```
../build/install/bin/ikos --display-checks all --display-inv all -a zzzzzzdbz test02.c
```

# What I Get
- How to add a checker (changing the `CheckerName` class and adding it to the
  python driver)
- What issuing diagnostics looks like (using the protected `_checks` field)
- How to tell if I want to check a particular `ar::Statement` (do a `dyn_cast`
  on the statement passed to the `check` method). 

# What I Don't Get
- Why there are several different classes that seem to be the same
  - It seems like `core::AbstractDomain<T>` reprsesents abstract values while
    `core::machine_int::AbstractDomain<T>` (or
    `core::memory::AbstractDomain<T>` etc) are the actual domains? I wanted to
    get another set of eyes on this, however.
- It seems like a finite lattice would be implemented using
  `core::DiscreteDomain` (see, for example `ikos::analyzer::LivenessDomain`),
  bbut this inherits from the `core::AbstractDomain` (which seemed like it was
  for abstract values) rather than an `AbstractDomain` that seems like it's
  for the actual domain.
- How do the fixpoint algorithms actually get run on each of these domains?
  Again, the liveness analysis is instructive (see
  `analyzer/src/analysis/liveness.cpp`), but there seems like several different
  choices of fixpoint iterators as well as a variety of potential options for
  each. It also seems like this requires subclassing a fixpoint iterator class
  and then doing a lot of analysis ourselves (e.g., it seems like it does all
  of the management of its store without any help from the rest of the
  framework).

