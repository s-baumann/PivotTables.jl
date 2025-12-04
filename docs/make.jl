using Documenter, JSPlots

makedocs(
    format = Documenter.HTML(),
    sitename = "JSPlots",
    modules = [JSPlots],
    pages = Any[
        "Introduction" => "index.md",
        "Examples" => "examples.md",
        "API" => "api.md"]
)

deploydocs(
    repo   = "github.com/s-baumann/JSPlots.jl.git",
    target = "build",
    deps   = nothing,
    make   = nothing
)
