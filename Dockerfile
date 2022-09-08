FROM rust:latest as base

# default location of Rust app
WORKDIR /usr/src/myapp

# install lld
RUN bash -c 'source /etc/os-release && echo "deb http://apt.llvm.org/${VERSION_CODENAME}/ llvm-toolchain-${VERSION_CODENAME} main"' > /etc/apt/sources.list.d/llvm.list && \
    (wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -) && \
    apt-get update && apt-get install -y lld-16 && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/bin/ld.lld-* /usr/bin/ld.lld && \
    ld.bfd --version && \
    ld.gold --version && \
    ld.lld --version

# install nightly and all the components in stable+nightly
# some components are not always available in nightly, fail
# the build in that case. Users can use previous docker image.
RUN rustup toolchain install nightly && \
    rustup component add clippy && \
    rustup component add rustfmt && \
    rustup component add clippy --toolchain nightly && \
    rustup component add rustfmt --toolchain nightly && \
    cargo install --locked cargo-deny && \
    cargo install cargo-release && \
    rm -rf /usr/local/cargo/registry

# self-test
FROM base as self-test
RUN git config --global user.email "you@example.com" && \
    git config --global user.name "Your Name"
RUN mkdir /tmp/self-test && \
    cd /tmp/self-test && \
    USER=test cargo init . && \
    cargo fmt && \
    cargo +nightly fmt && \
    cargo clippy && \
    cargo +nightly clippy && \
    cargo deny list && \
    ls -lah && \
    git add .gitignore Cargo* src && git commit -m 'init' && \
    cargo release --no-push --no-publish && \
    rm -rf /tmp/self-test

# final
FROM base
RUN rustc --version && \
    cargo --version && \
    cargo fmt --version && \
    cargo clippy --version && \
    cargo deny --version && \
    cargo release --version
