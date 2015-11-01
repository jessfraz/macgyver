FROM golang:1.5.1

COPY . /go/src/github.com/jfrazelle/macgyver
WORKDIR /go/src/github.com/jfrazelle/macgyver
RUN make

ENTRYPOINT ["./macgyver"]
