#!/bin/bash

# トラップ関数を定義する
trap 'echo "中断しました"; exit 1' INT

echo "nginx･letsencrypt をセットアップします。中断する際は ctrl + c を押してください"

# docke ディレクトリ
cd $(cd $(dirname $0) && pwd)
cd ../

cd letsencrypt/

# docker build
if docker-compose up -d --build; then
    echo "docker-composeが正常に実行されました"
else
    echo "docker-composeに失敗しました"
    exit 1
fi

echo "完了しました"