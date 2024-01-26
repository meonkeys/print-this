class ExtendedPDFConverter < (Asciidoctor::Converter.for 'pdf')
  register_for 'pdf'

  # Add an image at the start of each chapter.
  # see https://docs.asciidoctor.org/pdf-converter/latest/extend/use-cases/#chapter-image
  def ink_chapter_title sect, title, opts
    image_attrs = { 'target' => 'printer.png', 'pdfwidth' => '1in' }
    image_block = ::Asciidoctor::Block.new sect.document, :image, content_model: :empty, attributes: image_attrs
    convert_image image_block, relative_to_imagesdir: true, pinned: true
    super
  end

  # Render Colophon before TOC.
  # see https://docs.asciidoctor.org/pdf-converter/latest/extend/use-cases/#colophon-before-toc
  def ink_toc doc, num_levels, toc_page_number, start_cursor, num_front_matter_pages = 0
    colophon = (doc.instance_variable_get :@colophon) || (doc.sections.find {|sect| sect.sectname == 'colophon' })
    return super unless colophon
    go_to_page toc_page_number unless (page_number == toc_page_number) || scratch?
    if scratch?
      (doc.instance_variable_set :@colophon, colophon).parent.blocks.delete colophon
    else
      # if doctype=book and media=prepress, use blank page before table of contents
      go_to_page page_number.pred if @ppbook
      convert_section colophon
      go_to_page page_number.next
    end
    offset = @ppbook ? 0 : 1
    toc_page_numbers = super doc, num_levels, (toc_page_number + offset), start_cursor, num_front_matter_pages
    scratch? ? ((toc_page_numbers.begin - offset)..toc_page_numbers.end) : toc_page_numbers
  end
end

# Allow long words to wrap at slashes.
#
# See: https://asciidoctor.zulipchat.com/#narrow/stream/288690-users.2Fasciidoctor-pdf/topic/.E2.9C.94.20wrapping.20long.20words.3A.20break.20at.20slash
Prawn::Text::Formatted::LineWrap.prepend (Module.new do
  def break_chars(*)
    '/' + super
  end

  def word_division_scan_pattern(*)
    Regexp.union super, /\//
  end

  def scan_pattern(*)
    Regexp.union super, /\//
  end
end)
