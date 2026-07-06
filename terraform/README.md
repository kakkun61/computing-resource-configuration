# Terraform 設定

- Cloudflare
  - DNS
  - トンネル
- AWS
  - S3
  - IAM

## AWS

### 実行前提

- Region は `ap-northeast-3` を使う
- `make plan` / `make apply` を使う
- `plan` / `apply` は `aws-sso.ps1` を読み込み、`Set-AwsSsoEnv` で AWS 認証情報をセットしてから Terraform を実行する

### 実行手順

1. `aws login --profile terraform` を実行する
2. `make init` を実行する
3. `make plan` を実行する
4. 問題なければ `make apply` を実行する

### Make 変数

- `AWS_PROFILE` の既定値は `terraform`
- 例: `make plan AWS_PROFILE=default`

### 補足

- `terraform` ユーザーには管理者権限を付けない
- 手動で実行する場合は `aws-sso.ps1` を読み込み、`Set-AwsSsoEnv` 実行後に Terraform コマンドを実行する
- IAM は `terraform` ユーザー本体と、そのユーザーに付ける最小権限の inline policy を管理する
