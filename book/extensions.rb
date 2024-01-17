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

  # Add one invisible character to pages only containing running content.
  # This allows using `media: prepress` with some printers that don't like these sorta empty pages (e.g. Lulu).
  #
  # per Dan Allen:
  # > The likely culprit is the running content on otherwise empty pages.
  # > It's possible their analyzer thinks that is invalid for some reason (if it only sees a PDF stamp, which is what the running content is).
  #
  # See also:
  # * discussion https://asciidoctor.zulipchat.com/#narrow/stream/288690-users.2Fasciidoctor-pdf/topic/syntax.20error.20with.20prepress.20PDF.20on.20Lulu
  # * https://github.com/asciidoctor/asciidoctor-pdf/issues/2476
  # * https://github.com/asciidoctor/asciidoctor-pdf/issues/2477
  def ink_running_content periphery, doc, skip = [1, 1], body_start_page_number = 1
    super

    (1..page_count).each do |pgnum|
      go_to_page pgnum
      if page.empty?
        ink_prose ' '
      end
    end
  end
end
