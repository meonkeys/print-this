FROM ruby:3.3

ARG WORK_DIR
ARG USER
ARG UID
ARG GROUP
ARG GID

RUN addgroup --gid $GID $USER \
  && useradd --uid $UID --gid $GID --shell /bin/bash --no-create-home $USER

USER "$USER:$GROUP"

ENV HOME=$WORK_DIR

WORKDIR $WORK_DIR

COPY Gemfile .

RUN bundle install

USER root:root

COPY ./text_transformer.rb /usr/local/bundle/gems/asciidoctor-pdf-2.3.15/lib/asciidoctor/pdf/text_transformer.rb

USER "$USER:$GROUP"

CMD ["/bin/bash", ".internal-build.sh"]
