# AWSでEC2を利用してLaravel環境構築

環境構成
- AWS環境はTerraformにて構築
- AnsibleにてNginx, Php, php-fpmのインストールと各種設定
- CircleCiでrsyncデプロイ自動化

・構成図
![無題のプレゼンテーション (7)](https://github.com/user-attachments/assets/3aaf5cd0-f4c7-40de-b87e-7bc8d550ed5a)

・表示確認
![303701229-18f7b396-0d48-4116-bce5-584b96ddd91b](https://github.com/user-attachments/assets/880726b0-70ba-4b6f-a1e2-14125522d2a8)

## Terraform環境構築

- init. terrraform初期化
```
$ cd terraform/
$ terraform init
```

- plan(dry run). 構築環境に問題がないことを確認
```
$ terraform plan
```

- apply. 環境構築実行
```
$ terraform apply
```

## AnsibleにてNginx, Php, php-fpmのインストールと各種設定

### Ansible実行前の事前作業

1. ansible/ssh_configファイルを開き、EC2のインスタンスID i-xxxxxxxxxxx を2台とも編集。
  webserver1、webserver2の接続先を設定。
```
host webserver1
    ProxyCommand sh -c "aws ssm start-session --target i-xxxxxxxxxxx --document-name AWS-StartSSHSession --parameters 'portNumber=%p' --profile default --region ap-northeast-1"

host webserver2
    ProxyCommand sh -c "aws ssm start-session --target i-xxxxxxxxxxx --document-name AWS-StartSSHSession --parameters 'portNumber=%p' --profile default --region ap-northeast-1"
```

### Ansible実行

1. WSL2環境のターミナルにて、ansibleのディレクトリまで移動する。
```
$ cd /aws-laravel/ansible
```

2. playbook実行。
```
$ ansible-playbook -i hosts playbook.yml
```

## Laravel環境構築

### webserver 2台ともに同様の手順を実施

1. EC2コンソール [接続]>[セッションマネージャー] からEC2へ接続。

2. var/www/配下へ移動。
```
$ cd /var/www/
```

3. GitHubのMENTAリポジトリのクローンを実行(トークン発行済み)。
```
$ git clone https://${GIT_TOKEN}@github.com/${GIT_USER}/MENTA.git menta
```

4. ec2-userのホームディレクトリ配下へ移動。
```
$ cd /home/ec2-user
```

5. .envファイルを作成するmake_envfile.shスクリプトを実行。
```
$ sh make_envfile.sh
```

6. Laravelソースコード格納ディレクトリ配下へ移動。
```
$ cd /var/www/menta/laravel
```

7. 権限を付与
```
$ chmod -R 777 storage
$ chmod -R 777 bootstrap/cache
```

8. composer installを実行。
```
$ composer install
```

9. APP_KEYを生成。
```
$ php artisan key:generate
```

10. Lravel設定ファイルをキャッシュ。
```
$ php artisan config:cache
```

10. マイグレーション実行。
```
$ php artisan migrate
```

## CircleCIでの自動デプロイ

1. GitHubにプッシュされるとCirlceCI環境上でdeploy.shのスクリプトが実行。

2. 差分のあるファイルが/var/www/menta のリポジトリへ自動デプロイされ、マイグレーション実行。
