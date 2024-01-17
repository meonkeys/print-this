FROM ruby:3.3

ARG USER
ARG UID
ARG GROUP
ARG GID

WORKDIR /usr/src/app/book

RUN addgroup --gid $GID $USER \
  && useradd --uid $UID --gid $GID --shell /bin/bash --no-create-home $USER \
  && chown -R $USER:$GROUP /usr/src/app

USER "$USER:$GROUP"

ENV HOME=$WORKDIR

COPY Gemfile .

RUN bundle install

CMD ["/bin/bash", ".internal-build.sh"]
