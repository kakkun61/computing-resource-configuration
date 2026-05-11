# Terraform 設定

- Cloudflare
  - DNS
  - トンネル
- AWS
  - S3
  - IAM

## AWS

### 実行前提

- ローカル実行用の IAM ユーザーは `terraform` を使う
- AWS CLI の profile 名は `terraform` を使う
- Region は `ap-northeast-3` を使う

### 実行手順

1. `aws sts get-caller-identity --profile terraform` で `terraform` ユーザーになっていることを確認する
2. `terraform init` を実行する
3. `terraform plan` を実行する
4. 既存の AWS 設定は `terraform/import.tf` の import ブロックで state に取り込む
5. IAM の `terraform` ユーザーも同じ import ブロックで state に取り込む

### 補足

- `terraform` ユーザーには管理者権限を付けない
- Terraform は AWS profile で認証する
- IAM は `terraform` ユーザー本体と、そのユーザーに付ける最小権限の inline policy を管理する
