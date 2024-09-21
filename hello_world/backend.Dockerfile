FROM golang:1.22.4
WORKDIR ./backend

COPY ./backend/go.mod ./backend/go.sum .
RUN go mod download
COPY ./backend/ .

RUN pwd
RUN ls -l
RUN CGO_ENABLED=0 GOOS=linux go build -o /backend ./cmd/main
CMD ["/backend"]