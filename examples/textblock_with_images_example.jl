using JSPlots, DataFrames

println("Creating TextBlock with Images example...")

# Example 1: Company Header with Logo
company_header = TextBlock("""
<div style="display: flex; align-items: center; justify-content: space-between; background-color: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
    <div style="flex: 1;">
        <h1 style="margin: 0; color: #2c3e50;">TuxCorp Analytics</h1>
        <p style="margin: 5px 0 0 0; color: #7f8c8d;">Data-Driven Insights for Better Decisions</p>
    </div>
    <div style="flex: 0 0 auto;">
        {{IMAGE:logo}}
    </div>
</div>
""", Dict("logo" => "examples/pictures/images.jpeg"))

# Example 2: Text with Multiple Images
multi_image_content = TextBlock("""
<h2>Product Showcase</h2>
<p>Welcome to our product showcase. Here we demonstrate our flagship products:</p>

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin: 20px 0;">
    <div style="border: 1px solid #ddd; padding: 15px; border-radius: 8px;">
        <h3>Product A</h3>
        {{IMAGE:product_a}}
        <p>Our premium offering with advanced features.</p>
    </div>
    <div style="border: 1px solid #ddd; padding: 15px; border-radius: 8px;">
        <h3>Product B</h3>
        {{IMAGE:product_b}}
        <p>The essential solution for everyday needs.</p>
    </div>
</div>
""", Dict(
    "product_a" => "examples/pictures/images.jpeg",
    "product_b" => "examples/pictures/images.jpeg"
))

# Example 3: Report Header with Banner
report_header = TextBlock("""
<div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; border-radius: 10px; margin-bottom: 30px;">
    <div style="display: flex; align-items: center; gap: 20px;">
        <div style="flex: 0 0 auto;">
            {{IMAGE:company_icon}}
        </div>
        <div style="flex: 1;">
            <h1 style="margin: 0; font-size: 2.5em;">Q4 2024 Performance Report</h1>
            <p style="margin: 10px 0 0 0; font-size: 1.2em; opacity: 0.9;">Comprehensive Analysis & Insights</p>
        </div>
    </div>
</div>
""", Dict("company_icon" => "examples/pictures/images.jpeg"))

# Example 4: Simple Image in Text
simple_example = TextBlock("""
<h2>About Our Mascot</h2>
<div style="display: flex; align-items: start; gap: 20px;">
    <div style="flex: 0 0 200px;">
        {{IMAGE:mascot}}
    </div>
    <div style="flex: 1;">
        <p>Meet Tux, our beloved mascot! Tux has been representing our company since its inception, embodying the values of openness, collaboration, and innovation that drive our mission.</p>
        <p>As the face of our brand, Tux appears in all our marketing materials and serves as a constant reminder of our commitment to excellence and community.</p>
    </div>
</div>
""", Dict("mascot" => "examples/pictures/images.jpeg"))

# Example 5: TextBlock without images (backward compatibility)
plain_text = TextBlock("""
<h2>Traditional Text Block</h2>
<p>This is a traditional TextBlock without any images, demonstrating backward compatibility.</p>
<ul>
    <li>Works exactly as before</li>
    <li>No breaking changes</li>
    <li>Simple and straightforward</li>
</ul>
""")

# Create a sample chart for context
n = 500
df = DataFrame(
    value = randn(n) .* 10 .+ 100,
    category = rand(["A", "B", "C"], n)
)

chart = KernelDensity(:sample_chart, df, :df;
    value_cols = :value,
    group_cols = :category,
    title = "Sample Distribution",
    notes = "This chart demonstrates how TextBlocks with images integrate with regular charts"
)

conclusion = TextBlock("""
<h2>Summary</h2>
<p>This example demonstrates the enhanced TextBlock feature that now supports embedded images:</p>
<ul>
    <li><strong>Flexible Image Placement:</strong> Place images anywhere in your HTML using {{IMAGE:id}} syntax</li>
    <li><strong>Multiple Images:</strong> Include as many images as needed in a single TextBlock</li>
    <li><strong>Responsive Design:</strong> Images work with both embedded and external data formats</li>
    <li><strong>Backward Compatible:</strong> Existing TextBlocks without images continue to work unchanged</li>
</ul>
<p><em>Perfect for creating professional reports with logos, product images, and visual branding!</em></p>
""")

# Create page with both embedded and external format examples
page_embedded = JSPlotPage(
    Dict{Symbol,DataFrame}(:df => df),
    [company_header, multi_image_content, report_header, simple_example, chart, plain_text, conclusion],
    tab_title = "TextBlock with Images - Embedded",
    dataformat = :csv_embedded
)

page_external = JSPlotPage(
    Dict{Symbol,DataFrame}(:df => df),
    [company_header, multi_image_content, report_header, simple_example, chart, plain_text, conclusion],
    tab_title = "TextBlock with Images - External",
    dataformat = :parquet
)

create_html(page_embedded, "generated_html_examples/textblock_with_images_embedded.html")
create_html(page_external, "generated_html_examples/textblock_with_images_external")

println("\n" * "="^60)
println("TextBlock with Images examples created successfully!")
println("="^60)
println("\nFiles created:")
println("  • generated_html_examples/textblock_with_images_embedded.html (embedded format)")
println("  • generated_html_examples/textblock_with_images_external/ (external format with images folder)")
println("\nThis example demonstrates:")
println("  • Company header with logo")
println("  • Multiple images in grid layout")
println("  • Report banner with icon")
println("  • Side-by-side text and image")
println("  • Backward compatibility with plain TextBlocks")
