## 概要
action mailerを使ったメール送信の練習用のアプリです。

## バージョン
ruby・・・2.5.7<br>
rails・・・5.2.4.4<br>
nginx・・・1.19.3<br>
mysql・・・5.7

## ローカル環境での実行手順
dockerとdocker-composeを自分のpcにインストール

好きなディレクトリで<br>
`git clone https://github.com/Mac0917/mail_test.git`

移動<br>
`cd mail_test`

docker-composeを実行<br>
`docker-compose up -d`

データベース作成<br>
`docker exec -it goolemap_app_1 bash`(コンテナに入る)<br>
`rails db:create`<br>
`rails db:migrate`<br>

config/initializers/mail_config.rbを記述<br>
詳しくは「メール機能実装方法」の見出しより、メールサーバー(gmail yahoo)に合わせて設定する の部分をみる<br>

アクセス<br>
http://localhost/<br>

終了<br>
`exit`(コンテナから出る)<br>
`docker-compose stop`<br>
`docker-compose rm`<br>
`docker rmi mail_test_app mail_test_web`<br>
`docker volume rm mail_test-data mail_test-data mail_test-data`

リポジトリを削除<br>
`cd ..`<br>
`rm -rf mail_test`

## メール機能実装方法
メーラーを作成
`
rails generate mailer NotificationMailer (最後はファイル名なのでなんでもいい)
`

以下のファイルが作成される<br>
```
create  app/mailers/notification_mailer.rb  #メーラの設定を記述
create  app/views/notification_mailer　      #このフォルダにviewファイルを作成する
```

notification_mailer.rbに記述する
```
class NotificationMailer < ApplicationMailer
        default from: 'no-replay@gmail.com'

        #ここのアクション名が大事 mailのviewはnotification_mailerフォルダに アクション名.text.erbと記述                           html.erbでも大丈夫
        def complete_mail(user) 
          @user = user
          @url = "http://localhost:3000/users/#{@user.id}"    ここでのインスタンス変数はmailのviewで使う
          attachments['Gemfile.txt'] = File.read('Gemfile')   添付ファイルの設定　attachments['ファイル名'] = File.read('ファイルのフルパス')
          mail(subject: "COMPLETE join your address" ,to: @user.email)  これは件名である　　to: の後に複数のメールアドレスを指定することで複数のメールアドレスに送ることができる 配列でも可能 
        end
end
```

メールサーバー(gmail yahoo)に合わせて設定する gmailの場合<br>
config/initializers/mail_config.rbに記述する このファイルは自分で作成する
```
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address: 'smtp.gmail.com',
    domain: 'gmail.com',
    port: 587,
    user_name: 'メールアドレス',
    password: 'パスワード',
    authentication: 'plain',
    enable_starttls_auto: true
  }
```

このメールアドレスの設定をgoogleの方で変える<br>
<https://myaccount.google.com/lesssecureapps>にアクセスして安全姓の低いアプリへのアクセスを有効にする<br>
gmailでアカウント登録して自分のpcで使えるようにする<br>
gmailにアカウント登録しなかったら送れない



## メール送信処理
メーラークラス.メソッド(引数).deliver_now
``
例 NotificationMailer.complete_mail(@user).deliver_now 
``


## メールのメッセージの中でlink_toをつかうには
 config/environmental/development.rb
  ```
     config.action_mailer.default_url_options = { host: 'localhost:3000'}
  ```
 "localhost:3000"のところはドメイン名
<br>
development.rbは開発環境の設定なので
ドメイン名はlocalhost:3000でいいが
production.rbでは本番環境のドメインを書く

urlはpath名+urlで記述できる<br>
例えば<br>
sex_choice_pathだと<br>
sex_choice_urlでurlがでてくる


## 本番環境 
本番環境でもaction mailerは使える<br>
それでもawsの機能を使うとき<br>
awsのときは
`
gem 'aws-sdk-rails'
`
config/enviromment/production.rb
``
  #awsサポート
  config.action_mailer.delivery_method = :ses
``


### 追記
パスワードのところはgmailのアプリパスワードから発行されたパスワードを設定する<br>
参考<br>
https://senrenseyo.com/20210830/rails6-devisegmail/