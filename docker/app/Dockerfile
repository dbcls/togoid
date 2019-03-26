FROM ruby:2.6.0

RUN curl -sL "https://deb.nodesource.com/setup_8.x" | bash - && \
    curl -sS "https://dl.yarnpkg.com/debian/pubkey.gpg" | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

RUN apt-get update && \
    apt-get install -y nodejs yarn virtuoso-opensource-6.1-bin && \
    rm -rf /var/lib/apt/lists/*

RUN gem install bundler && \
    echo -e "---\nBUNDLE_PATH: \"vendor/bundle\"" >/usr/local/bundle/config

ADD docker-entrypoint.sh /

WORKDIR app

EXPOSE 3000 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start-server"]
