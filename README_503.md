Run these in the root of this repo to build:
```
cmake -S . -B build -DCMAKE_INSTALL_PREFIX=$PWD/build/install -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
pushd build && cmake --build . && make install && popd
```

Then, `build/install/bin/ikos` is the created ikos executable.

Because `ikos` produces a database file in the directory where it's run, I recommend
running the tests from `test-503/`, e.g.,
```
../build/install/bin/ikos --display-checks all --display-inv all -a zzzzzzdbz test02.c
```
