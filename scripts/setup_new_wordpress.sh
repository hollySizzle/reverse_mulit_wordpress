#!/bin/bash

# トラップ関数を定義する
trap 'echo "中断しました"; exit 1' INT

echo "新しいwordpressを作成します。中断する際は ctrl + c を押してください"
echo "追加したいドメインを入力してください"
read domain

# ドメインが空かどうかをチェックする
if [ -z "$domain" ]; then
    echo "ドメインが入力されていません"
    exit 1
fi
domain_formatted=$(echo $domain | tr '.' '_')

# docke ディレクトリ
cd $(cd $(dirname $0) && pwd)
cd ../


if [ ! -d "app/template_wordpress" ]; then
    mkdir app/template_wordpress
    git clone https://github.com/hollySizzle/docker_wordpress_template ./app/template_wordpress/
fi

# テンプレートからコピー
cp -r app/template_wordpress/package app/$domain
cd app/$domain


# 引数の定義
db_name="db_${domain_formatted}"
db_user="user_${domain_formatted}"
db_passowrd=$(head /dev/urandom | tr -dc A-Za-z0-9\!\@\#\$\%\^\&\*\(\) | head -c 16)
db_root_password=$(head /dev/urandom | tr -dc A-Za-z0-9\!\@\#\$\%\^\&\*\(\) | head -c 16)

# sedコマンドを使って内容Xを内容Aに置き換える
file=.env
sed -i "s/VIRTUAL_DOMAIN=your_domain/VIRTUAL_DOMAIN=$domain/g" $file

sed -i "s/MYSQL_ROOT_PASSWORD=db_root_password/MYSQL_ROOT_PASSWORD=$db_root_password/g" $file
sed -i "s/WORDPRESS_DB_NAME=wp_db_name/WORDPRESS_DB_NAME=$db_name/g" $file
sed -i "s/WORDPRESS_DB_USER=wp_db_user/WORDPRESS_DB_USER=$db_user/g" $file
sed -i "s/WORDPRESS_DB_PASSWORD=db_pass/WORDPRESS_DB_PASSWORD=$db_passowrd/g" $file

sed -i "s/MYSQL_DATABASE=db_name/MYSQL_DATABASE=$db_name/g" $file
sed -i "s/MYSQL_USER=db_user/MYSQL_USER=$db_user/g" $file
sed -i "s/MYSQL_PASSWORD=db_pass/MYSQL_PASSWORD=$db_passowrd/g" $file

echo "Your MySQL user Password is:${db_passowrd}"

# docker build
if docker-compose up -d --build; then
    echo "docker-composeが正常に実行されました"
else
    echo "docker-composeに失敗しました"
    exit 1
fi

echo "完了しました"