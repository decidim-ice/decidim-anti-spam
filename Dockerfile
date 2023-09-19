
FROM hfroger/decidim:0.26.8-dev as bundler
COPY . /home/decidim/decidim_module_spam
RUN cd /home/decidim/app \
    && bundle config set --global path "vendor" \
    && bundle config set --global without "" \
    && bundle config --global build.nokogiri --use-system-libraries \
    && bundle config --global build.charlock_holmes --with-icu-dir=/usr/include \
    && bundle config --global path "$BUNDLE_PATH" \
    # Add the gem with a local path (bounded as volume)
    && echo "gem \"decidim-spam_signal\", path: \"../decidim_module_spam\"" >> Gemfile \
    && bundle
    
FROM hfroger/decidim:0.26.8-dev
ENV NODE_ENV=development \
    RAILS_ENV=development \
    BUNDLE_WITHOUT=""
# Add locally the current rep in module, 
# This will be bound as volume later.
COPY . /home/decidim/decidim_module_spam
# Add app configuration for working in dev.
COPY ./.docker/config /home/decidim/app/config

RUN bundle config set --global path "vendor" \
    && bundle config set --global without "" \
    && bundle config --global build.nokogiri --use-system-libraries \
    && bundle config --global build.charlock_holmes --with-icu-dir=/usr/include \
    && bundle config --global path "$BUNDLE_PATH" 

RUN npm install -D webpack-dev-server
COPY --from=bundler /home/decidim/app/Gemfile /home/decidim/app/Gemfile
COPY --from=bundler /home/decidim/app/Gemfile.lock /home/decidim/app/Gemfile.lock
COPY --from=bundler /home/decidim/app/vendor /home/decidim/app/vendor