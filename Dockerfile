# syntax=docker/dockerfile:1.4
# ARMネイティブのAlpineイメージを使用（軽量化）
FROM ruby:3.2.2-alpine AS base

# 必要なパッケージのみインストール
RUN apk add --no-cache \
    build-base \
    mariadb-dev \
    mariadb-client \
    tzdata \
    bash \
    wget \
    gcompat

# 依存関係のインストール（BuildKitキャッシュマウント活用）
FROM base AS deps
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN --mount=type=cache,target=/usr/local/bundle/cache \
    bundle config set --local path '/usr/local/bundle' && \
    bundle config set --local without 'test' && \
    bundle install -j4 --retry 3 && \
    bundle clean --force

# 開発環境
FROM base AS dev
WORKDIR /app

# 依存関係をコピー
COPY --from=deps /usr/local/bundle /usr/local/bundle
COPY . .

# bootsnap用のディレクトリ作成
RUN mkdir -p /tmp/bootsnap && \
    rm -rf tmp/* log/*

# Rails環境変数
ENV RAILS_ENV=development
ENV RAILS_LOG_TO_STDOUT=true
ENV BOOTSNAP_CACHE_DIR=/tmp/bootsnap

EXPOSE 3001
CMD ["bundle", "exec", "rails", "s", "-p", "3001", "-b", "0.0.0.0"]
