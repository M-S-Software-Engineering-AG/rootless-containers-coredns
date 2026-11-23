variable "REGISTRY" {
  default = "ghcr.io/m-s-software-engineering-ag"
}

# renovate: datasource=github-releases depName=coredns/coredns
variable "COREDNS_VERSION" {
  default = "v1.15.0"
}

# renovate: datasource=github-releases depName=M-S-Software-Engineering-AG/coredns-envvar-corefile
variable "COREFILE_GEN_VERSION" {
  default = "v1.1.3"
}

# renovate: datasource=github-releases depName=M-S-Software-Engineering-AG/container-supervisor
variable "SUPERVISOR_VERSION" {
  default = "v1.11.5"
}

# renovate: datasource=github-releases depName=M-S-Software-Engineering-AG/container-healthcheck
variable "HEALTHCHECK_VERSION" {
  default = "v1.0.0"
}

variable "IMAGE_REVISION" {
  default = "6.4"
}

group "default" {
  targets = ["coredns", "coredns-debug"]
}

target "coredns" {
  context    = "."
  dockerfile = "Dockerfile"
  args       = {
    COREDNS_VERSION      = COREDNS_VERSION
    COREFILE_GEN_VERSION = COREFILE_GEN_VERSION
    SUPERVISOR_VERSION   = SUPERVISOR_VERSION
    HEALTHCHECK_VERSION  = HEALTHCHECK_VERSION
  }
  tags       = [
    "${REGISTRY}/rootless-containers-coredns:${COREDNS_VERSION}-${IMAGE_REVISION}",
    "${REGISTRY}/rootless-containers-coredns:${COREDNS_VERSION}-${regex_replace(IMAGE_REVISION, "\\.[0-9]+$", "")}",
    "${REGISTRY}/rootless-containers-coredns:latest",
  ]
  platforms  = [
    "linux/amd64",
    "linux/arm64",
    "linux/arm/v7",
  ]
}

target "coredns-debug" {
  inherits = ["coredns"]
  args     = {
    BASE_IMAGE = "gcr.io/distroless/static-debian13:debug-nonroot"
  }
  tags     = [
    "${REGISTRY}/rootless-containers-coredns:${COREDNS_VERSION}-${IMAGE_REVISION}-debug",
    "${REGISTRY}/rootless-containers-coredns:${COREDNS_VERSION}-${regex_replace(IMAGE_REVISION, "\\.[0-9]+$", "")}-debug",
    "${REGISTRY}/rootless-containers-coredns:latest-debug",
  ]
}
