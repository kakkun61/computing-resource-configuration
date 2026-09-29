# hollo-international-fixed-calendar

実行には認証情報が要る。

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: env
  namespace: hollo-international-fixed-calendar
stringData:
  ACCESS_TOKEN: ""
```

アクセストークン（スコープ `write:statuses`）の取得のしかたを示す。

アプリを登録して client_id と client_secret を得る

```console
curl -X POST https://ap.kakkun61.com/api/v1/apps \
  -F client_name=hollo-international-fixed-calendar \
  -F redirect_uris=urn:ietf:wg:oauth:2.0:oob \
  -F scopes=write:statuses
```

ブラウザーで次の URL を開き、投稿するアカウントを選んで許可すると認可コードが表示される。

https://ap.kakkun61.com/oauth/authorize?response_type=code&client_id=<client_id>&redirect_uri=urn:ietf:wg:oauth:2.0:oob&scope=write:statuses

認可コードをアクセストークンに交換する

```console
curl -X POST https://ap.kakkun61.com/oauth/token \
  -F grant_type=authorization_code \
  -F code=<authorization_code> \
  -F client_id=<client_id> \
  -F client_secret=<client_secret> \
  -F redirect_uri=urn:ietf:wg:oauth:2.0:oob
```
