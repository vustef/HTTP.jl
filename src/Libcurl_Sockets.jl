module Libcurl_Sockets

export Libcurl_TCPSocket, connect!

import Sockets
using Sockets: IPv4, IPv6
using LibCURL

mutable struct Libcurl_TCPSocket <: IO
    status::Int
    buffer::IOBuffer
    cond::Base.ThreadSynchronizer
    readerror::Any
    sendbuf::Union{IOBuffer, Nothing}
    lock::ReentrantLock # advisory lock
    throttle::Int
    handle::Ptr{Nothing}

    function Libcurl_TCPSocket()
        new(
            0,
            PipeBuffer(),
            Base.ThreadSynchronizer(),
            nothing,
            nothing,
            ReentrantLock(),
            Base.DEFAULT_READ_BUFFER_SZ,
            # uninit handle for now
        )
    end
end

function Sockets.nagle(::Libcurl_TCPSocket, ::Bool) end

function connect!(sock::Libcurl_TCPSocket, host::AbstractString, port::Integer)
    curl = curl_easy_init() # TODO @vustef: Switch to libcurl multi interface for async.
    sock.handle = curl
    curl_easy_setopt(curl, CURLOPT_URL, host)
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1)
end

function Sockets.wait_connected(x::Libcurl_TCPSocket)
    # error("unimplemented $(StackTraces.stacktrace()[1].func)")
end

function Sockets.getsockname(sock::Libcurl_TCPSocket)
    error("unimplemented $(StackTraces.stacktrace()[1].func)")
end

function Sockets.getpeername(sock::Libcurl_TCPSocket)
    error("unimplemented $(StackTraces.stacktrace()[1].func)")
end

function Base.bytesavailable(s::Libcurl_TCPSocket)
    error("unimplemented $(StackTraces.stacktrace()[1].func)")
end

function Base.unsafe_read(s::Libcurl_TCPSocket, p::Ptr{UInt8}, nb::UInt)
    error("unimplemented $(StackTraces.stacktrace()[1].func)")
end

function Base.unsafe_write(s::Libcurl_TCPSocket, p::Ptr{UInt8}, n::UInt)
    error("unimplemented $(StackTraces.stacktrace()[1].func)")
    # TODO @vustef: NOTE: Cannot implement this, since libcurl doesn't expose TCP interface.
    # Need to switch to lower-level library instead.
end

function Base.write(s::Libcurl_TCPSocket, x::UInt8)
    error("unimplemented $(StackTraces.stacktrace()[1].func)")
end

function Base.isopen(s::Libcurl_TCPSocket)
    error("unimplemented $(StackTraces.stacktrace()[1].func)")
end

function Base.eof(s::Libcurl_TCPSocket)
    error("unimplemented $(StackTraces.stacktrace()[1].func)")
end

function Base.close(s::Libcurl_TCPSocket)
    error("unimplemented $(StackTraces.stacktrace()[1].func)")
end

end
