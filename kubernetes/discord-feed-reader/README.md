# discord-feed-reader

discord-feed-post 用の設定ファイルが要る。Discord のウェブフック URL が含まれるため、パブリックにできない。

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: discord-feed-post-config
  namespace: discord-feed-reader
data:
  config.yaml: |-
    hatenablog://blog/12704346814673868829: https://discord.com/api/webhooks/{webhook.id}/{webhook.token}
```
