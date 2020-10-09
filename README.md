メール機能実装方法

メーラーを作成
rails generate mailer NotificationMailer (最後はファイル名なのでなんでもいい)

create  app/mailers/notification_mailer.rb メーラの設定を記述
create    app/views/notification_mailer　このフォルダにviewファイルを作成する



notification_mailer.rbに記述する
class NotificationMailer < ApplicationMailer
        default from: 'no-replay@gmail.com'
      
        def complete_mail(user) ここのアクション名が大事    mailのviewはnotification_mailerフォルダに アクション名.text.erbと記述する html.erbでも行けた
          @user = user
          @url = "http://localhost:3000/users/#{@user.id}"    ここでのインスタンス変数はmailのviewで使う
          attachments['Gemfile.txt'] = File.read('Gemfile')   添付ファイルの設定　attachments['ファイル名'] = File.read('ファイルのフルパス')
          mail(subject: "COMPLETE join your address" ,to: @user.email)  これは件名である　　to: の後に複数のメールアドレスを指定することで複数のメールアドレスに送ることができる 配列でも可能 
        end
end


メールサーバー(gmail yahoo)に合わせて設定する gmailの場合
config/initializers/mail_config.rbに記述する
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

このメールアドレスの設定をgoogleの方で変える
<https://myaccount.google.com/lesssecureapps>にアクセスして安全姓の低いアプリへのアクセスを有効にする
gmailでアカウント登録してmacosで使えるようにする gmailにアカウント登録しなかったら送れなかった



メール送信処理
メーラークラス.メソッド(引数).deliver_now

 NotificationMailer.complete_mail(@user).deliver_now 



 ### 
 mailの中でlink_toをつかうには
 config/environmental/development.rbで
     config.action_mailer.default_url_options = { host: 'localhost:3000'}

 "localhost:3000"のところはドメイン名

development.rbは開発環境の設定なので
ドメイン名はlocalhost:3000でいいが
 
 production.rbでは本番環境のドメインを書く



本番環境 awsのときは
gem 'aws-sdk-rails'
config/enviromment/production.rbのところに
# #awsサポート
  config.action_mailer.delivery_method = :ses
  を書く



