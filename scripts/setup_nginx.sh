#!/bin/bash

# トラップ関数を定義する
trap 'echo "中断しました"; exit 1' INT

echo "nginx･letsencrypt をセットアップします。中断する際は ctrl + c を押してください"
echo "letsencryptに使用するデフォルトメールアドレスを入力してください"
read mail

# ドメインが空かどうかをチェックする
if [ -z "$
" ]; then
    echo "ドメインが入力されていません"
    exit 1
fi

# docke ディレクトリ
cd $(cd $(dirname $0) && pwd)
cd ../
cd nginx-proxy/


# env書き換え
sed -i "s/DEAULT_EMAIL = default_email/DEAULT_EMAIL = $mail/g" .env

cd '/nginx-proxy'

# docker build
if docker-compose up -d --build; then
    echo "docker-composeが正常に実行されました"
else
    echo "docker-composeに失敗しました"
    exit 1
fi

echo "完了しました"