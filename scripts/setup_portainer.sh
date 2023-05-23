#!/bin/bash

# トラップ関数を定義する
trap 'echo "中断しました"; exit 1' INT

echo "portainerをセットアップします。中断する際は ctrl + c を押してください"
echo "portainerのドメインを入力してください"
read domain

# ドメインが空かどうかをチェックする
if [ -z "$domain" ]; then
    echo "ドメインが入力されていません"
    exit 1
fi

# docke ディレクトリ
cd $(cd $(dirname $0) && pwd)
cd ../
cd app/portainer

# 書き換え
sed -i "s/VIRTUAL_DOMAIN=your_domain/VIRTUAL_DOMAIN=$domain/g" .env

# docker build
if docker-compose up -d --build; then
    echo "docker-composeが正常に実行されました"
else
    echo "docker-composeに失敗しました"
    exit 1
fi

echo "完了しました"