# DSA

Data structures and algorithms practice.

## Setup

Install zig:

```
cd ~/Downloads/
wget https://ziglang.org/download/0.13.0/zig-linux-x86_64-0.13.0.tar.xz
tar xvf zig-linux-x86_64-0.13.0.tar.xz
sudo ln -sfv ~/Downloads/zig/zig-linux-x86_64-0.13.0/zig /usr/bin/zig
```
```
$ zig version
0.13.0
```

Checkout this repository

```
git clone https://github.com/jethrodaniel/dsa
cd dsa/zig

zig build
```

## Run tests

```
# no output means everything passed
zig build test

# or more verbosely
zig build test --summary all
```

## View documentation

```
zig build docs
python3 -m http.server 8808 -d zig-out/docs
```

Then visit http://localhost:8808/
