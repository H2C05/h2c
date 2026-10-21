RUN dnf install -y mariadb105 ca-certificates shadow-utils && \
    dnf clean all&& \
    dnf clean all

# 2. 创建普通用户
RUN useradd -m -u 1000 appuser

# 3. 创建应用数据目录并设置权限
RUN mkdir -p /mnt/formstar && \
    chown -R appuser:appuser /mnt/formstar

# 4. 设置工作目录
WORKDIR /app

# 5. 复制应用程序并设置权限
COPY --chown=appuser:appuser formstar-v2 ./formstar-v2
RUN chmod 755 ./formstar-v2

# 6. 配置应用环境变量
ENV DB_HOST=database-1.cluster-ckdwgusmuke0.us-east-1.rds.amazonaws.com
# 根据rds数据进行更改
ENV DB_USER=admin
ENV DB_PORT=3306
ENV DB_NAME=formstar
ENV EFS_MOUNT_PATH=/mnt/formstar
ENV SUBMISSIONS_TABLE=formstar-submissions
ENV AWS_REGION=us-east-1

# 7. 使用普通用户运行应用
USER appuser

# 8. 声明应用端口
EXPOSE 8080

# 9. 启动应用
CMD ["./formstar-v2"]
