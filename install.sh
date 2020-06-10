pkg install python
sudo apt-get install python-django
pip3 install psutil
pip3 install Django
pip3 install djangorestframework
pip3 install django-cors-headers
pip3 install django-sslserver
pip3 install django-crispy-forms
pkg install libjpeg-turbo
pip3 install Pillow
pip3 install sorl-thumbnail
pip3 install pytube3
pip3 install google-api-python-client
pip3 install django-extra-fields
python3 manage.py migrate
python3 manage.py makemigrations users
python3 manage.py makemigrations music
python3 manage.py makemigrations mobile
python3 manage.py migrate
 echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'diffusion')" | python3 manage.py shell
 python3 manage.py migrate
