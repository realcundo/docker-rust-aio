FROM rust:latest

RUN rustup component add clippy && \
    rustup component add rustfmt && \
    cargo install cargo-deny && \
    rustc --version && \
    cargo --version && \
    cargo fmt --version && \
    cargo clippy --version && \
    cargo deny --version
