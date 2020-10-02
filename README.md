# docker-rust-aio
Debian Buster based Docker image with cargo [fmt](https://github.com/rust-lang/rustfmt), [clippy](https://github.com/rust-lang/rust-clippy), [release](https://github.com/sunng87/cargo-release) and [deny](https://github.com/EmbarkStudios/cargo-deny) enabled.

Useful to run cargo tools in your local CI without having to install cargo components manually.

Based on the latest official [Rust docker image](https://github.com/rust-lang/docker-rust) with both `stable` and `nightly` toolchains and tools enabled.
Target triple: `*-x86_64-unknown-linux-gnu`.

### Included `cargo` commands:
- `check`, `test`, `build`, `tree`, `doc`: included in [base Rust image](https://github.com/rust-lang/docker-rust)
- `clippy`: https://github.com/rust-lang/rust-clippy
- `deny`: https://github.com/EmbarkStudios/cargo-deny
- `release`: https://github.com/sunng87/cargo-release
- `fmt`: https://github.com/rust-lang/rustfmt

### Available linkers:
- `ld.bfd`: https://sourceware.org/binutils
- `ld.gold`: https://sourceware.org/binutils
- `ld.lld` (v12) https://lld.llvm.org

The docker image is built daily and if all tools are available, the image is pushed to [Docker Hub](https://hub.docker.com/r/realcundo/docker-rust-aio).
The image is guaranteed to have all listed tools available both in `stable` and `nightly`.

Currently only `:latest` tag is available.

## Running
Run as a local user using Rust project in local `$PWD`:
```bash
docker run
  --rm \
  -t \
  --user "$(id -u)":"$(id -g)" \
  -v "$PWD:/usr/src/myapp" \
  realcundo/docker-rust-aio \
  cargo clippy
```
To preserve cargo build files between runs (e.g. for incremental builds), use
```bash
mkdir "$LOCAL_RUST_CARGO_CACHE"
docker run \
  --rm \
  -t \
  --user "$(id -u)":"$(id -g)" \
  -v "$PWD:/usr/src/myapp" \
  -v "$LOCAL_RUST_CARGO_CACHE:/usr/local/cargo/registry" \
  realcundo/docker-rust-aio \
  cargo clippy
```
Make sure that `$LOCAL_RUST_CARGO_CACHE` exists before running the docker container. Otherwise it'll be created by docker as a root user and your local user won't be able to access it.

## Contributing
Feel free to open PRs to include your favourite cargo component.

## Links
- Github: https://github.com/realcundo/docker-rust-aio
- Docker Hub: https://hub.docker.com/r/realcundo/docker-rust-aio
