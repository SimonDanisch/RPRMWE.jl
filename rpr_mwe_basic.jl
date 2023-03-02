using RadeonProRender_jll

# Can be replaced by any path to the library and then used without RadeonProRender_jll
const librprp64 = RadeonProRender_jll.libRadeonProRender64

struct rpr_shape_t
    _::Ptr{Cvoid}
end
struct rpr_context_t
    _::Ptr{Cvoid}
end

const rpr_context = Ptr{rpr_context_t}
const rpr_shape = Ptr{rpr_shape_t}
const RPR_VERSION_MAJOR_MINOR_REVISION = 0x00200217
const RPR_API_VERSION = RPR_VERSION_MAJOR_MINOR_REVISION
const rpr_char = Cchar
struct rpr_shape_t
    _::Ptr{Cvoid}
end
const rpr_uint = Cuint
const rpr_shape = Ptr{rpr_shape_t}
struct rpr_context_properties_t
    _::Ptr{Cvoid}
end

const rpr_context_properties = Ptr{rpr_context_properties_t}

function rprContextSetActivePlugin(context, pluginID)
    check_error(ccall((:rprContextSetActivePlugin, librprp64), Cint, (rpr_context, Cint), context, pluginID))
end

function rprRegisterPlugin(path)
    ccall((:rprRegisterPlugin, librprp64), Cint, (Ptr{rpr_char},), path)
end

function plugin_path(plugin::Symbol)
    if plugin == :Tahoe
        return RadeonProRender_jll.libTahoe64
    elseif plugin == :Northstar
        return RadeonProRender_jll.libNorthstar64
    end
    Sys.isapple() && error("Only Tahoe and Northstar are supported")
    path_base = dirname(RadeonProRender_jll.libNorthstar64)
    # Hybrid isn't currently part of Binarybuilder products, since its missing on Apple
    if plugin == Hybrid
        return joinpath(path_base, "Hybrid.$(Libdl.dlext)")
    elseif plugin == HybridPro
        return joinpath(path_base, "HybridPro.$(Libdl.dlext)")
    end
end

function check_error(error_code)
    error_code == 0 && return
    return error("Error code returned: $(error_code)")
end


function rprCreateContext(api_version, pluginIDs, pluginCount, creation_flags, props, cache_path)
    out_context = Ref{rpr_context}()
    check_error(ccall((:rprCreateContext, librprp64), Cint,
                      (rpr_uint, Ptr{Cint}, Cint, rpr_uint, Ptr{rpr_context_properties}, Ptr{rpr_char},
                       Ptr{rpr_context}), api_version, pluginIDs, pluginCount, creation_flags, props,
                      cache_path, out_context))
    return out_context[]
end

function Context(plugin; resource=16)
    id = rprRegisterPlugin(plugin_path(plugin))
    @assert(id != -1)
    plugin_ids = [id]
    ctx_ptr = rprCreateContext(RPR_API_VERSION, plugin_ids, 1, resource, C_NULL, C_NULL)
    rprContextSetActivePlugin(ctx_ptr, id)
    return ctx_ptr
end

# https://radeon-pro.github.io/RadeonProRenderDocs/en/sdk/api/rprcontextcreatemesh.html
function rprContextCreateMesh(context, vertices, num_vertices, vertex_stride, normals, num_normals,
                              normal_stride, texcoords, num_texcoords, texcoord_stride, vertex_indices,
                              vidx_stride, normal_indices, nidx_stride, texcoord_indices, tidx_stride,
                              num_face_vertices, num_faces, out_mesh)
    return check_error(ccall((:rprContextCreateMesh, librprp64), Int32,
                             (rpr_context, Ptr{Float32}, Cint, Cint, Ptr{Float32}, Cint, Cint,
                              Ptr{Float32}, Cint, Cint, Ptr{Cint}, Cint, Ptr{Cint}, Cint,
                              Ptr{Cint}, Cint, Ptr{Cint}, Cint, Ptr{rpr_shape}), context, vertices,
                             num_vertices, vertex_stride, normals, num_normals, normal_stride, texcoords,
                             num_texcoords, texcoord_stride, vertex_indices, vidx_stride, normal_indices,
                             nidx_stride, texcoord_indices, tidx_stride, num_face_vertices, num_faces,
                             out_mesh))
end

function shape(context,
        vraw::Vector{Float32}, nraw::Vector{Float32}, iraw::Vector{Cint},
        uvraw::Vector{Float32})
    nfaces = length(iraw) ÷ 3
    facelens = fill(Cint(3), nfaces)
    mesh = Ref{rpr_shape}()
    rprContextCreateMesh(
        context, vraw,
        length(vraw) ÷ 3, sizeof(Float32)*3, nraw, length(nraw) ÷ 3,
        sizeof(Float32)*3, uvraw, length(uvraw) ÷ 2, sizeof(Float32)*2, iraw,
        sizeof(Cint), iraw, sizeof(Cint), iraw, sizeof(Cint),
        facelens, nfaces, mesh)
    return mesh[]
end

function rprContextSetParameterByKeyString(context, in_input, value)
    return check_error(ccall((:rprContextSetParameterByKeyString, libRadeonProRender64), Int32,
                             (rpr_context, UInt32, Ptr{rpr_char}), context, in_input, value))
end
function rprContextSetParameterByKey1u(context, in_input, x)
    return check_error(ccall((:rprContextSetParameterByKey1u, libRadeonProRender64), Int32,
                             (rpr_context, UInt32, rpr_uint), context, in_input, x))
end



context = Context(:Northstar; resource=16)
rprContextSetParameterByKeyString(context, 361, joinpath(@__DIR__, "rpr_trace"))
rprContextSetParameterByKey1u(context, 360, 1)

v = Float32[0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0,
        0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0,
        1.0, 0.0, 1.0, 1.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 1.0, 1.0, 0.0, 0.0,
        1.0, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0]
n = Float32[-1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0,
            0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0,
            -1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0, 0.0, 0.0, 1.0, 0.0,
            0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0]
uvraw = Float32[1.0, 1.0, 1.0, 1.0, 0.0, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0, 0.0, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0, 0.0,
        1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 1.0]
iraw = Cint[0, 1, 2, 0, 2, 3, 4, 5, 6, 4, 6, 7, 8, 9, 10, 8, 10, 11, 12, 13, 14, 12, 14, 15, 16, 17, 18,
                16, 18, 19, 20, 21, 22, 20, 22, 23]
shape(context, v, n, iraw, uvraw)
