### Run celery

celery -A celery_mail_pdf.celery worker --loglevel=info

### Run flask app

python celery_mail_pdf.py
