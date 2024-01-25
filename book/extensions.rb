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

  # Wrap at slashes. Improves word-wrapping for long file paths.
  # See https://asciidoctor.zulipchat.com/#narrow/stream/288690-users.2Fasciidoctor-pdf/topic/.E2.9C.94.20wrapping.20long.20words.3A.20break.20at.20slash/near/418152314
  def typeset_text string, line_metrics, opts = {}
    string = string.gsub %r|(?<=\w)\/|, '/' + ZeroWidthSpace
    super
  end
end
