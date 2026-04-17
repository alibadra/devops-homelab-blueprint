ui = true

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = "true"  # TLS handled by Traefik
}

storage "file" {
  path = "/vault/data"
}

api_addr     = "http://0.0.0.0:8200"
cluster_addr = "http://0.0.0.0:8201"
