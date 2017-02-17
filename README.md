# snidl

Just point your `A` record to the service running **snidl**, and it will gladly
serve your IPv6-only servers to an IPv4-audience over TLS **with intact
end-to-end security**. This is done by taking the TLS SNI header, making a DNS
look-up to that name and then proxying towards the resulting AAAA record.

**Important: snidl is not new, but an alternative implementation
of [snip](https://github.com/jornane/node-snip).** Built with the very
performant [OpenResty](https://github.com/openresty/) (nginx) and Lua. Tested
with openresty-1.11.2.2 on FreeBSD 11.0-RELEASE.

snidl should in theory be pretty fast once it starts hitting caching, but proper
benchmarking remains to be performed. If it turns out to be slow, it might be
renamed to snigl (snail) :)

## Getting started

Install OpenResty. On FreeBSD 11, this is done like so:

```sh
$ pkg install devel/gmake security/openssl devel/pcre
$ cd openresty-VERSION/
$ ./configure --with-pcre-jit --with-ipv6 -j2
$ gmake && gmake install
```

## Future work

- Set up test enviroment.
- Optimize nginx for proxying.
