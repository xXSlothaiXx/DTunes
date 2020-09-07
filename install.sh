sudo apt-get install python3-pip
sudo apt-get install python-django
pip3 install requests
pip3 install Django
pip3 install djangorestframework
pip3 install django-cors-headers
pip3 install django-crispy-forms
pkg install libjpeg-turbo
pip3 install Pillow
pip3 install django-extra-fields
pip3 install youtube_dl
python3 manage.py migrate
python3 manage.py makemigrations dtunes
python3 manage.py migrate
 echo "from django.contrib.auth.models import User; User.objects.create_superuser('DTunes', 'admin@example.com', 'diffusion')" | python3 manage.py shell
 python3 manage.py migrate
