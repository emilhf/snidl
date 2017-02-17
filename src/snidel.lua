-- TODO, package as module? https://github.com/openresty/lua-resty-lrucache
-- TODO: Consider tcpsock:sslhandshake?
-- TODO: Clean up ugly code

local resolver = require "resty.dns.resolver"
local ssl = require "ngx.ssl"
local lrucache = require "resty.lrucache"

-- Init cache for DNS AAAA queries
local dns_cache, err = lrucache.new(200)
if not dns_cache then
    return error("failed to create the cache: " .. (err or "unknown"))
end

-- Use UNINETT resolvers for PoC
local r, err = resolver:new {
    nameservers = { "158.38.0.1" }
}
if not r then
    ngx.say("couldn't load resolver: ", err)
    return ngx.error
end

local function get_inet6_by_dns(sni)
    local aaaa, err = r:query(sni, { qtype = r.TYPE_AAAA })
    if not aaaa or next(aaaa) == nil then
        ngx.say("Couldn't query DNS server for AAAA record. Error: ", err)
        return ngx.error
    end
    for i, record in ipairs(aaaa) do
        if record.address then
            return record.address
        end
    end
    ngx.say("Invalid setup. snidl requires at least one AAAA record. Error: ", err)
    return ngx.error
end

-- Get SNI
local sni, err = ssl.server_name()
if not sni then
    ngx.say("Client didn't set SNI. Are you using HTTPS? Error: ", err)
    return ngx.error
end

local ip6 = dns_cache:get(sni)
-- Cache miss, do DNS query
if not ip6 then
    ip6_raw = get_inet6_by_dns(sni)
    -- For now, just use first address. Wrap it to be safe.
    ip6 = "[" .. ip6_raw .. "]"
end

-- Success!

-- Update LRU cache
dns_cache:set(sni, ip6)
-- Print something
-- print("wow, got", ip6)

-- Return result to nginx
ngx.var.upstream = ip6
