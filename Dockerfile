# FROM python:3.7.2-stretch

# WORKDIR /app

# COPY requirements.txt ./
# RUN pip install --no-cache-dir -r requirements.txt
# RUN pip install --no-cache-dir uwsgi

# COPY . .

# CMD [ "python", "./your-daemon-or-script.py" ]
# RUN celery -A celery_mail_pdf.celery worker --loglevel=info

# # Expose port 5000 for uwsgi
# EXPOSE 5000
# EXPOSE 5672

# ENTRYPOINT ["uwsgi", "--http", "0.0.0.0:5000", "--env-file","config.env", "--module", "celery_mail_pdf:app", "--processes", "1", "--threads", "8"]
FROM tiangolo/uwsgi-nginx-flask:python3.7

# copy over our requirements.txt file
# Doing this here will enable caching for cases where just the source code changed
# Caching enables faster builds
COPY requirements.txt /tmp/

# upgrade pip and install required python packages
RUN pip install -U pip
RUN pip install -r /tmp/requirements.txt

# copy over our app code
COPY . /app

# RUN groupadd user && useradd --create-home --home-dir /home/user -g user user

# Declare the working directory
WORKDIR /app/

# CMD celery -A celery_mail_pdf.celery worker --loglevel=info

# RUN { \
# 	echo 'import os'; \
# 	echo "BROKER_URL = os.environ.get('CELERY_BROKER_URL', 'amqp://')"; \
# } > celeryconfig.py

# # --link some-rabbit:rabbit "just works"
# ENV CELERY_BROKER_URL amqp://guest@rabbit

# USER user
CMD ["celery", "worker"]

# EXPOSE 5000
# EXPOSE 5672

# ENTRYPOINT ["uwsgi", "--http", "0.0.0.0:5000","--env-file","config.env","--restart","always","--name","my_async_app"]

# set an environmental variable, MESSAGE,
# which the app will use and display
ENV MESSAGE "hello from Docker"

# Port to expose
# EXPOSE 80