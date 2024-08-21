module DividerHelper
    def generate_divider(text, margin_bottom = 20)
      html = <<-HTML
      <div class="divider" style="margin-bottom: #{margin_bottom}px; width:100%; margin-top: 20px; border-bottom: 2px dashed #80808069;">
        <span>#{text}</span>
        <span></span>
      </div>
      HTML

      html.html_safe
    end



    def generate_border
      html = <<-HTML
        <div class="divider" style="margin-bottom: 20px; margin-top: 20px; border-top: 2px dashed #80808069;">
        </div>
      HTML

      return html.html_safe
    end
end
