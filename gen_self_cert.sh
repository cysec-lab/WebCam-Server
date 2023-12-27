#!/bin/bash

# 設定
DOMAIN="fakeserver.com"
PRIVATE_KEY="fakeserver.key"
CSR="fakeserver.csr"
CERTIFICATE="fakeserver.crt"

# 秘密鍵の生成
openssl genrsa -out $PRIVATE_KEY 2048

# 証明書署名要求（CSR）の作成
openssl req -new -key $PRIVATE_KEY -out $CSR -subj "/CN=$DOMAIN"

# 自己署名証明書の生成
openssl x509 -req -days 1825 -in $CSR -signkey $PRIVATE_KEY -out $CERTIFICATE

echo "自己署名証明書が生成されました。"
echo "秘密鍵: $PRIVATE_KEY"
echo "証明書: $CERTIFICATE"
