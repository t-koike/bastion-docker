# bastion-docker

A Dockerfile to create an SSH server for Internet open.

## Requirement

Host server is assumed to be Ubuntu 18.04(Bionic).

## Usage
### Install Docker
```
bash ./install-docker.sh
```

### Build Image
```
bash ./build.sh
```

### Run Container
```
bash ./run.sh
```

## What to do after starting the container

### QRコード発行
`run.sh` では port 番号 10000 をsshd のポートを解放しています。
まずは、生成したid_rsa を利用して通常通り鍵認証でアクセスします。

```
ssh login.user@{インスタンスのIPアドレス} -p 10000 -i ./id_rsa
```

ログインに成功すると、MFA の認証用QRコードがmotdとして表示されます。
それを利用して、google authnticator 等に追加認証ワンタイムコードを発行します。

### QRコード発行後
MFA デバイスに登録できたらあとは一旦logout します。(そうしないとMFAが有効にならないです)
その後再度

```
ssh login.user@{インスタンスのIPアドレス} -p 10000 -i ./id_rsa
```

でアクセスすると、

```
Verification code:
```

というプロンプトがでるので、先ほど登録したMFA デバイスの認証ワンタイムコードを入力すればlogin に成功します。
