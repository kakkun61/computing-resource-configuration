# Build stage
FROM --platform=$BUILDPLATFORM golang:1.26 AS builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

WORKDIR /workspace

COPY go.mod go.sum main.go ./

RUN go mod download

RUN case "$TARGETARCH" in \
      "arm") \
        case "$TARGETVARIANT" in \
          "v7") export GOARM=7 ;; \
          "v6") export GOARM=6 ;; \
          *) export GOARM=5 ;; \
        esac ;; \
    esac && \
    CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags="-w -s" -o /hollo-international-fixed-calendar .

# Final stage
FROM gcr.io/distroless/base-debian12:nonroot

COPY --from=builder /hollo-international-fixed-calendar /usr/local/bin/hollo-international-fixed-calendar

ENTRYPOINT ["/usr/local/bin/hollo-international-fixed-calendar"]
