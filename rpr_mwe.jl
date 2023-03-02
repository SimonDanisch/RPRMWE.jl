using RadeonProRender, GeometryBasics
const RPR = RadeonProRender
using RadeonProRender: Shape, rpr_int

function shape(context::RPR.Context, vraw::Vector{Point3f}, nraw::Vector{Vec3f}, iraw::Vector{RPR.rpr_int},
               uvraw::Vector{Vec2f})
    nfaces = length(iraw) ÷ 3
    facelens = fill(rpr_int(3), nfaces)
    foreach(i -> checkbounds(vraw, i + 1), iraw)
    foreach(i -> checkbounds(nraw, i + 1), iraw)
    foreach(i -> checkbounds(uvraw, i + 1), iraw)
    rpr_mesh = RPR.RPR.rprContextCreateMesh(context, vraw, length(vraw), sizeof(Point3f), nraw, length(nraw),
                                            sizeof(Vec3f), uvraw, length(uvraw), sizeof(Vec2f), iraw,
                                            sizeof(rpr_int), iraw, sizeof(rpr_int), iraw, sizeof(rpr_int),
                                            facelens, nfaces)

    jl_references = (vraw, nraw, uvraw, iraw, facelens)
    shape = Shape(rpr_mesh, context, jl_references)
    push!(context.objects, shape)
    return shape
end

let
    path = joinpath(@__DIR__, "rpr_trace")
    !isdir(path) && mkpath(path)
    context = RPR.Context(; resource=RPR.RPR_CREATION_FLAGS_ENABLE_CPU)
    RPR.rprContextSetParameterByKeyString(context, RPR.RPR_CONTEXT_TRACING_PATH, path)
    RPR.rprContextSetParameterByKey1u(context, RPR.RPR_CONTEXT_TRACING_ENABLED, 1)
    m = uv_normal_mesh(Rect3f(Vec3f(0), Vec3f(1)))
    v, n, fs, uv = decompose(Point3f, m), normals(m), faces(m), texturecoordinates(m)
    uvraw = map(uv -> Vec2f(1 - uv[2], 1 - uv[1]), uv)
    f = decompose(TriangleFace{OffsetInteger{-1,rpr_int}}, fs)
    iraw = collect(reinterpret(rpr_int, f))
    shape(context, v, n, iraw, uvraw)
end
