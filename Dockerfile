FROM public.ecr.aws/docker/library/alpine:3.22.2

ARG USER_NAME=test_user
ARG USER_PASSWORD=verysecret
ARG PASV_ADDRESS=127.0.0.1
ARG PASV_MIN_PORT=21000
ARG PASV_MAX_PORT=21010

# ftpサーバーのインストール
RUN apk add --no-cache vsftpd

# ftpサーバーの設定ファイルをコピー 
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf

# サーバー起動スクリプトを実行
COPY --chmod=755 entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]