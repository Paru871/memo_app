# memo_app(DB利用)

## アプリの概要
Sinatraを使った簡単なメモwebアプリのリボジトリです。
Fjord Boot Camp(フィヨルドブートキャンプ)のプラクティス「Sinatraを使ってWebアプリケーションの基本を理解する⇨WebアプリからのDB利用」の課題の提出物です。

## CRUD処理を実装
メモの追加・削除・一覧表示・詳細表示・編集を行います。

## DEMO
![demo](https://gyazo.com/e48bfdf3f454b69e82022de2a8a2b869/raw)

## ローカル環境での実行方法

### DATABASE(PostgreSQL)の準備

まずは実行するローカル環境にPostgreSQLのインストールを行った後、以下の手順でデータベース及びテーブルを作成します。

【PostgreSQLのインストール方法】
[\[macOS High Sierra\]\[Homebrew\] PostgreSQL のインストールからDB作成まで \- Qiita](https://qiita.com/ksh-fthr/items/b86ba53f8f0bccfd7753)

作成するデータベース名:`memos_db`, テーブル名:`memos_t`

1. `$ psql -U アカウント名` ・・・PostgreSQLの自分のアカウントにログイン
2. `アカウント名=# CREATE DATABASE memos_db;` ・・・`memos_db`というデータベースを作成
3. `アカウント名=# \q` ・・・`\q`でいったんpsqlを終了
4. `$ psql -U アカウント名 memos_db` ・・・`memos_db`に接続
5. 下記を入力してテーブル`memos_t`を作成
```
CREATE TABLE memos_t (
id serial NOT NULL,
title text NOT NULL,
content text NOT NULL,
time timestamptz NOT NULL,
PRIMARY KEY (id)
);
```
以上でデータベースとテーブルの準備は完了です。

### 必要なファイルのクローンとGemのインストール

1. `git clone https://github.com/paru871/memo_app` ファイルをローカル環境の任意の場所に複製(クローン)
2. `cd memo_app` コピーしたディレクトリに移動
3. `bundle install`を実行、Gemfileに記載した必要なGemをインストール
4. `memo_app.rb`を実行
5. `http://localhost:4567`にブラウザに入力してアプリを表示→利用スタート！
