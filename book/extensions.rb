class ExtendedPDFConverter < (Asciidoctor::Converter.for 'pdf')
  register_for 'pdf'

  # see https://docs.asciidoctor.org/pdf-converter/latest/extend/use-cases/#chapter-image
  def ink_chapter_title sect, title, opts
    if (image_path = sect.attr 'image')
      image_attrs = { 'target' => image_path, 'pdfwidth' => '1in' }
      image_block = ::Asciidoctor::Block.new sect.document, :image, content_model: :empty, attributes: image_attrs
      convert_image image_block, relative_to_imagesdir: true, pinned: true
    end
    super
  end

  # Loop over all pages. Add something to empty pages, e.g. an invisible glyph
  # (maybe just an ASCII 0x20 space character?).
  # see https://asciidoctor.zulipchat.com/#narrow/stream/288690-users.2Fasciidoctor-pdf/topic/syntax.20error.20with.20prepress.20PDF.20on.20Lulu
  def ink_running_content periphery, doc, skip = [1, 1], body_start_page_number = 1
    super

    (1..page_count).each do |pgnum|
      go_to_page pgnum
      if page.empty?
        # FIXME - add something we can see, for now
        text 'xyz'
      end
    end
  end
end
