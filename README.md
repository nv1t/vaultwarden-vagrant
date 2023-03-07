# Vaultwarden

> Alternative implementation of the Bitwarden server API written in Rust and compatible with upstream Bitwarden clients, perfect for self-hosted deployment where running the official resource-heavy service might not be ideal. - ([dani-garcia/vaultwarden](https://github.com/dani-garcia/vaultwarden))

This is a vagrant implementation with compilation from the github source. The provision file needs internet access as it clones the github vaultwarden repository and the releases of the bw_client_builds repository directly.

It uses caddy as a reverse proxy and forwards port 8080.

It uses VirtualBox as a provider and modifies the memory and cpu cores to use 4096 RAM and 2 CPUs.

# Installation

```bash
$ vagrant box add ubuntu/lunar64
$ vagrant up
```

# References
* https://github.com/dani-garcia/vaultwarden
* https://github.com/dani-garcia/bw_web_builds/releases
