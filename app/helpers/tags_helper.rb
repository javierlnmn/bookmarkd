module TagsHelper
  TAG_COLOR_DEFAULT = "#a1a1aa"
  TAG_BACKGROUND_ALPHA = "20"

  def tag_color_hex(tag)
    tag.color.presence || TAG_COLOR_DEFAULT
  end

  def tag_container_style(tag)
    hex = tag_color_hex(tag)
    "background: #{hex}#{TAG_BACKGROUND_ALPHA}; border-color: #{hex};"
  end

  def tag_text_style(tag)
    "color: #{tag_color_hex(tag)};"
  end
end
