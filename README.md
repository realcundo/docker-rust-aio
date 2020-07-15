# rust-aio
Debian-based Docker image with cargo fmt, clippy and deny enabled.

## Running
Run as a local user building using Rust project in `$LOCAL_RUST_PROJECT_DIR`:
```bash
docker run --rm -t --user "$(id -u)":"$(id -g)" -v "$LOCAL_RUST_PROJECT_DIR:/usr/src/myapp" -w /usr/src/myapp  XXX cargo clippy
```
To preserve cargo build files between runs (e.g. for incremental builds), use
```bash
mkdir "$LOCAL_RUST_CARGO_CACHE"
docker run --rm -t --user "$(id -u)":"$(id -g)" -v "$LOCAL_RUST_PROJECT_DIR:/usr/src/myapp" -v "$LOCAL_RUST_CARGO_CACHE:/usr/local/cargo/registry" -w /usr/src/myapp  XXX cargo clippy
```
Make sure that `$LOCAL_RUST_CARGO_CACHE` exists before running the docker container. Otherwise it'll be created by docker as a root and your user won't be able to access it.
