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

# self-test
RUN mkdir /tmp/self-test && \
    cd /tmp/self-test && \
    USER=test cargo init . && \
    cargo fmt && \
    cargo clippy && \
    cargo deny list && \
    rm -rf /tmp/self-test
