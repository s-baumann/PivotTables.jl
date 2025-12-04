using JSPlots, DataFrames

println("Creating 3D Chart examples...")

# Prepare header
header = TextBlock("""
<h1>3D Chart Examples</h1>
<p>This page demonstrates 3D surface plots in JSPlots using Plotly.</p>
<ul>
    <li><strong>Single surface:</strong> Basic 3D surface visualization</li>
    <li><strong>Multiple surfaces:</strong> Compare multiple groups on the same 3D plot</li>
    <li><strong>Interactive controls:</strong> Rotate, zoom, and pan to explore from all angles</li>
    <li><strong>Color gradients:</strong> Automatic color schemes for different groups</li>
</ul>
<p><em>Click and drag to rotate the 3D plots. Use scroll wheel to zoom!</em></p>
""")

# Example 1: Basic 3D Surface - Mathematical Function
x_range = -5:0.2:5
y_range = -5:0.2:5
surface_df = DataFrame()

for x in x_range
    for y in y_range
        z = sin(sqrt(x^2 + y^2))
        push!(surface_df, (x=x, y=y, z=z, group="Ripple"))
    end
end

chart1 = Chart3d(:basic_surface, :surface_data;
    x_col = :x,
    y_col = :y,
    z_col = :z,
    group_col = :group,
    title = "3D Surface: sin(√(x² + y²))",
    x_label = "X",
    y_label = "Y",
    z_label = "Z",
    notes = "Classic ripple pattern - demonstrates basic 3D surface visualization"
)

# Example 2: Multiple Surfaces - Comparing Functions
multi_surface_df = DataFrame()

for x in -5:0.3:5
    for y in -5:0.3:5
        # Surface 1: Sine wave
        z1 = sin(sqrt(x^2 + y^2))
        push!(multi_surface_df, (x=x, y=y, z=z1, group="Sine"))

        # Surface 2: Cosine wave (shifted)
        z2 = cos(sqrt(x^2 + y^2)) - 1.5
        push!(multi_surface_df, (x=x, y=y, z=z2, group="Cosine"))

        # Surface 3: Combination
        z3 = 0.5 * (sin(x) * cos(y)) + 1.5
        push!(multi_surface_df, (x=x, y=y, z=z3, group="Combined"))
    end
end

chart2 = Chart3d(:multi_surfaces, :multi_data;
    x_col = :x,
    y_col = :y,
    z_col = :z,
    group_col = :group,
    title = "Multiple 3D Surfaces Comparison",
    x_label = "X Axis",
    y_label = "Y Axis",
    z_label = "Height",
    notes = "Multiple surfaces with different color gradients - demonstrates grouping feature"
)

# Example 3: Combined with Image
example_image = joinpath(@__DIR__, "pictures", "images.jpeg")
pic = Picture(:viz_example, example_image;
             notes = "Example visualization")

# Create a wave interference pattern
wave_df = DataFrame()

for x in -10:0.5:10
    for y in -10:0.5:10
        # Two wave sources creating interference
        r1 = sqrt((x-3)^2 + (y-3)^2)
        r2 = sqrt((x+3)^2 + (y+3)^2)

        wave1 = sin(r1) / (r1 + 0.1)
        wave2 = sin(r2) / (r2 + 0.1)

        z = wave1 + wave2

        push!(wave_df, (x=x, y=y, z=z, group="Interference"))
    end
end

chart3 = Chart3d(:wave_interference, :wave_data;
    x_col = :x,
    y_col = :y,
    z_col = :z,
    group_col = :group,
    title = "Wave Interference Pattern",
    x_label = "X Position",
    y_label = "Y Position",
    z_label = "Amplitude",
    notes = "Interference pattern from two wave sources - great for physics simulations"
)

conclusion = TextBlock("""
<h2>Key Features Summary</h2>
<ul>
    <li><strong>Interactive 3D controls:</strong> Click and drag to rotate, scroll to zoom, shift+drag to pan</li>
    <li><strong>Multiple surface support:</strong> Compare different datasets on the same plot</li>
    <li><strong>Automatic color gradients:</strong> Each group gets a distinct color scheme</li>
    <li><strong>Scientific applications:</strong> Perfect for mathematical functions, simulations, and terrain data</li>
    <li><strong>Integration:</strong> Combine with other plot types, images, and text blocks</li>
</ul>
<p><strong>Tip:</strong> Hover over the surface to see exact x, y, z coordinates!</p>
""")

# Create single combined page
page = JSPlotPage(
    Dict{Symbol,DataFrame}(
        :surface_data => surface_df,
        :multi_data => multi_surface_df,
        :wave_data => wave_df
    ),
    [header, chart1, chart2, pic, chart3, conclusion],
    tab_title = "3D Chart Examples"
)

create_html(page, "generated_html_examples/threedchart_examples.html")

println("\n" * "="^60)
println("3D Chart examples created successfully!")
println("="^60)
println("\nFile created: generated_html_examples/threedchart_examples.html")
println("\nThis page includes:")
println("  • Basic 3D surface plot")
println("  • Multiple surfaces with grouping")
println("  • Wave interference pattern")
println("  • Integration with images and text")
