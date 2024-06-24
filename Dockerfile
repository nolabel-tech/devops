FROM ubuntu:latest
LABEL authors="bagautdinov"

ENTRYPOINT ["top", "-b"]