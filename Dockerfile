FROM rust:latest

# default location of Rust app
WORKDIR /usr/src/myapp

RUN rustup component add clippy && \
    rustup component add rustfmt && \
    cargo install cargo-deny && \
    rm -rf /usr/local/cargo/registry && \
    rustc --version && \
    cargo --version && \
    cargo fmt --version && \
    cargo clippy --version && \
    cargo deny --version
