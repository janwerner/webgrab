Docker container for WebGrab+Plus 2.0
=====================================

-   Uses [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker)

-   Based on
    [tobbenb/docker-containers](https://github.com/tobbenb/docker-containers)

-   Updated for [WebGrab+Plus 2.0](http://www.webgrabplus.com/)

-   To use your own config, create a volume map for `/config` and create
    `./config/WebGrab++.config.xml` and optionally `./config/mdb/mdb.config.xml`
    & `./config/rex/rex.config.xml`

-   If no config exists, default config (German free-to-air channels from
    `vodafone.de`) will be used

-   XMLTV guide data is output to `/data/tvguide.xml` (create a volume map for
    `/data` to access)
