module MessageRequest

using URIs
using ..IOExtras, ..Messages, ..Parsers

export messagelayer

"""
    messagelayer(handler) -> handler

Construct a [`Request`](@ref) object from method, url, headers, and body.
Hard-coded as the first layer in the request pipeline.
"""
function messagelayer(handler)
    return function(method::String, url::URI, headers::Headers, body; response_stream=nothing, http_version=v"1.1", kw...)
        req = Request(method, resource(url), headers, body; url=url, version=http_version, responsebody=response_stream)
        local resp
        try
            resp = handler(req; response_stream=response_stream, kw...)
        finally
            if @isdefined(resp) && iserror(resp) && haskey(resp.request.context, :response_body)
                if isbytes(resp.body)
                    resp.body = resp.request.context[:response_body]
                else
                    write(resp.body, resp.request.context[:response_body])
                end
            end
        end
    end
end

end # module MessageRequest
