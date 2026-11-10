# Dependency-free numerical research CLI. Formal audits use Containerfile.proofs.
FROM docker.io/library/rust:1.95-slim-bookworm@sha256:d7482085ff5b415f84dba5647ae71606650bdef00db7aeb69f4b3d170c3e4082 AS build
WORKDIR /build
COPY Cargo.toml Cargo.lock ./
COPY src ./src
RUN cargo build --locked --release --bin pudding
FROM docker.io/library/debian:bookworm-slim
COPY --from=build /build/target/release/pudding /usr/local/bin/pudding
USER 65532:65532
WORKDIR /tmp
ENTRYPOINT ["pudding"]
CMD ["--help"]
