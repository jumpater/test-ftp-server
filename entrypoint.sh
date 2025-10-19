#!/bin/sh
set -e

cat <<EOF
==========================================
FTP Server Configuration
==========================================
PASV Address: ${PASV_ADDRESS}
PASV Port Range: ${PASV_MIN_PORT}-${PASV_MAX_PORT}
==========================================
EOF

# ローカルユーザー作成とパスワード設定
adduser -D -h "/home/${USER_NAME}" -s /sbin/nologin "${USER_NAME}"
echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd

# ホームディレクトリを作成
mkdir -p "/home/${USER_NAME}"
chown ${USER_NAME}:${USER_NAME} "/home/${USER_NAME}"
chmod 500 "/home/${USER_NAME}"

# ftp用サブディレクトリを作成
mkdir -p "/home/${USER_NAME}/ftp"
chown ${USER_NAME}:${USER_NAME} "/home/${USER_NAME}/ftp"
chmod 700 "/home/${USER_NAME}/ftp"

# ポートとアドレスを設定ファイルに反映
sed -i "s/pasv_address=.*/pasv_address=${PASV_ADDRESS}/" /etc/vsftpd/vsftpd.conf
sed -i "s/pasv_min_port=.*/pasv_min_port=${PASV_MIN_PORT}/" /etc/vsftpd/vsftpd.conf
sed -i "s/pasv_max_port=.*/pasv_max_port=${PASV_MAX_PORT}/" /etc/vsftpd/vsftpd.conf

cat <<EOF
==========================================
Starting vsftpd...
==========================================
EOF

exec vsftpd /etc/vsftpd/vsftpd.conf
