# バックエンド (Ruby on Rails)

## 1. 概要

このリポジトリは、在宅勤務管理-MYTECNO のバックエンドアプリケーションです。Ruby on Rails (APIモード) を使用しています。
開発環境の起動やGitの運用ルールについては、親リポジトリの `README.md` を参照してください。

## 2. 技術スタック

-   フレームワーク: [Ruby on Rails](https://rubyonrails.org/) (APIモード)
-   言語: [Ruby](https://www.ruby-lang.org/ja/)
-   データベース: [MySQL](https://www.mysql.com/jp/)
-   テスト: [RSpec](https://rspec.info/) (導入予定)

## 3. APIエンドポイント設計

-   **URL設計:** RESTfulな設計を基本とします。
-   **バージョン管理:** (例: `/api/v1/...` のようにURLにバージョンを含めます。)
-   **認証:** (例: JWT (JSON Web Token) を使用します。)
-   詳細なAPI仕様は、別途API仕様書 (Swagger, API Blueprintなど) で管理します。

## 4. コーディング規約

-   [RuboCop](https://github.com/rubocop/rubocop) の規約に準拠します。コミット前に自動チェックが走る設定を推奨します。
-   その他、チームで定めたルールがあれば追記します。

## 5. ディレクトリ構成 (主要なもの)

```
backend/
├── app/
│   ├── controllers/    # APIのエンドポイントとなるコントローラー
│   ├── models/         # データベースとのやり取りを行うモデル
│   └── ...
├── config/
│   └── routes.rb       # URLとコントローラーのアクションを紐付けるルーティング
├── db/
└── ...
