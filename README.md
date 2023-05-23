# reverse_some_wordpress

## description
Docekerで複数ドメインに対応したWordpressコンテナのイメージ  
サーバーの初期設定スクリプトは以下  
https://github.com/hollySizzle/centos7_startup  
wordpress_templateはここからcloneする  
https://github.com/hollySizzle/docker_wordpress_template  
  
## howToUse
### 作業ディレクトリの作成
~~~
cd /docker
~~~
  
ない場合  
~~~
sudo mkdir /docker
sudo chown -R :docker /docker
sudo chmod g+s /docker
sudo chmod g+rwx /docker
~~~
  
### git clone
~~~
cd /docker
~~~
  
/dockerの中身をclone  
~~~
git clone https://github.com/hollySizzle/reverse_mulit_wordpress .
~~~
  
**git がない場合**
~~~
sudo yum install git
~~~

### docker build
デフォルトで存在するはずだけど一応  
~~~
docker network create shared
~~~
  
~~~
cd /docker/
~~~
  
### ビルドスクリプトの実行
~~~
cd /docker
~~~
  
nginx スタートアップスクリプト  
~~~
sh scripts/setup_nginx.sh
~~~
  
確認
~~~
# サーバーのIPを確認
hostname -I
~~~
~~~
# サーバーのIPを確認
wget <ipアドレス>  
# ERROR 503: Service Temporarily Unavailable.と表示されれば正常
~~~
  
letsencrpyt スタートアップスクリプト  
~~~
sh scripts/setup_letsencrpyt.sh 
~~~

  
poertiner スタートアップスクリプト(任意)  
~~~
sh scripts/setup_portainer.sh
~~~
  
wordpress スタートアップスクリプト(任意)  
~~~
sh scripts/setup_new_wordpress.sh
~~~
  
## 手動でインストールする場合

#### nginx コンテナの作成
~~~
docker-compose -f nginx-proxy/docker-compose.yml up -d --build
~~~
  
IPにアクセスし503が出れば成功  
  
#### proxy-letsencrypt コンテナの作成
~~~
docker-compose -f  letsencrypt/docker-compose.yml up -d --build
~~~
  
#### portainerコンテナの作成
portainer用のドメインを.envファイルに書き込む  
~~~
vi ./app/portainer/.env
~~~
  
portainerコンテナのビルド  
~~~
docker-compose -f  app/portainer/docker-compose.yml up -d --build
~~~
  
ドメインにアクセスするとportainerが起動している  
  
#### wordpressコンテナの作成
wordpress用のドメインを.envファイルに書き込む  
~~~
vi ./app/default_domain_wordpress/.env
~~~
  
wordpressコンテナのビルド  
~~~
docker-compose -f app/default_domain_wordpress/docker-compose.yml up -d --build
~~~
  
# wordpressサイトを追加するとき
docker/app/template_wordpressをappに複製し以下を実行  
  
ドメインの実行  
~~~
vi ./app/複製したディレクトリ名/.env
~~~

~~~
docker-compose -f app/複製したディレクトリ名/docker-compose.yml up -d --build
~~~

# 参考
https://qwx.jp/sakura-vps-docker-multi-wordpress-ssl/?utm_source=pocket_reader  

