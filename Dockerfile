FROM rust:latest

# default location of Rust app
WORKDIR /usr/src/myapp

# install nightly and all the components in stable+nightly
# some components are not always available in nightly, fail
# the build in that case. Users can use previous docker image.
RUN rustup toolchain install nightly && \
    rustup component add clippy && \
    rustup component add rustfmt && \
    rustup component add clippy --toolchain nightly && \
    rustup component add rustfmt --toolchain nightly && \
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
    cargo +nightly fmt && \
    cargo clippy && \
    cargo +nightly clippy && \
    cargo deny list && \
    rm -rf /tmp/self-test
