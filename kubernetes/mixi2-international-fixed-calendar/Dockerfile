# Build stage
FROM --platform=$BUILDPLATFORM golang:1.26 AS builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

WORKDIR /workspace

RUN git clone https://github.com/kakkun61/mixi2-international-fixed-calendar.git . && \
    go mod download

RUN case "$TARGETARCH" in \
      "arm") \
        case "$TARGETVARIANT" in \
          "v7") export GOARM=7 ;; \
          "v6") export GOARM=6 ;; \
          *) export GOARM=5 ;; \
        esac ;; \
    esac && \
    CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags="-w -s" -o /mixi2-international-fixed-calendar .

# Final stage
FROM gcr.io/distroless/base-debian12:nonroot

COPY --from=builder /mixi2-international-fixed-calendar /usr/local/bin/mixi2-international-fixed-calendar

ENTRYPOINT ["/usr/local/bin/mixi2-international-fixed-calendar"]
