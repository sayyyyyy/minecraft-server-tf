# minecraft-server-tf
## 概要
Minecraftマルチサーバーを作成するTerraFormソースコード群

## 作成するリソース
### Base
- VPC
- InternetGateway
- Subnet
- RouteTable
- SecurityGroup
- IAM Role

### EC2
- EC2 Instance

### Scheduler
- IAM Role
- EventBridge Scheduler

## 使い方

1. [こちら](https://mcversions.net/)のサイトで遊びたいバージョンのサーバーのダウンロードリンクを取得する
    - バージョンを選択し、Download Server jarを右クリックしてリンクをコピーする
2. TerraFormをインストールする
3. 環境変数を設定する
    - AWSの認証に必要なアクセスキーなど
4. terraform init を実行する
5. terraform applyを実行する
    - インスタンス起動のタイミングで[EULA](https://www.minecraft.net/ja-jp/terms/r3)に自動的に同意するため注意
    - 1でコピーしたリンクを変数として入力する
    - リージョンはap_northeast_1にしているため、他のリージョンを利用する場合は変更する必要がある
6. AWSマネジメントコンソールからEC2の画面を開き、パブリックIPv4アドレスをコピーする
7. MinecraftでサーバーIPの欄にパブリックIPv4アドレスを入力してサーバーに接続する
    - EC2インスタンスが作成された後もインスタンス内部で設定を行っているため10分程待ってからアクセスする必要がある
8. 遊び終わったらEC2インスタンスを停止する
    - 稼働させている限り料金が発生してしまう
    - 停止ではなく終了してしまうとデータが消えてしまうので、理由がない限り停止を推奨