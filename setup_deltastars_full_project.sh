#!/bin/bash
set -euo pipefail
# ========================================================
# setup_deltastars_full_project.sh
# Comprehensive one-click setup for Deltastars store
# Creates project skeleton, Docker, PWA, imports products,
# creates admins, and runs everything locally for testing.
# ========================================================

# ---------- CONFIG - قم بتعديل هذه القيم إذا أردت قبل التشغيل ----------
# Domain for local testing (add to /etc/hosts -> 127.0.0.1 deltastars.local)
DOMAIN="deltastars.local"

# Google Drive direct-download link to products excel (use uc?export=download&id=FILEID)
# Example: https://drive.google.com/uc?export=download&id=1ncgLWgU7451YY8W9B8-fnSWJho9BrpQN
GDRIVE_PRODUCTS_LINK="${GDRIVE_PRODUCTS_LINK:-https://drive.google.com/uc?export=download&id=1ncgLWgU7451YY8W9B8-fnSWJho9BrpQN}"

# Google Drive docs - manager id, trade license, tax (optional)
GDRIVE_MANAGER_ID_LINK="${GDRIVE_MANAGER_ID_LINK:-https://drive.google.com/uc?export=download&id=1MidaG2glKPgOMGPQgN28M4ks-YbUM8vH}"
GDRIVE_TRADE_LICENSE_LINK="${GDRIVE_TRADE_LICENSE_LINK:-https://drive.google.com/uc?export=download&id=1ZhiuIawZC6SPEf91tXR2lfZM4jo10JDY}"
GDRIVE_TAX_LINK="${GDRIVE_TAX_LINK:-https://drive.google.com/uc?export=download&id=12mBYsWHZuQgHLu0DF6ddQnK4Tkwm60ON}"

# Default admin users (will be created automatically inside Django)
ADMIN1_EMAIL="INFO@DELTASTARS-KSA.COM"
ADMIN1_PASS="Admin123!"
ADMIN2_EMAIL="deltastars777@gmail.com"
ADMIN2_PASS="Admin123!"

# Company contact (used in frontend manifest and footer)
COMPANY_EMAIL="INFO@DELTASTARS-KSA.COM"
COMPANY_PHONE="00966920023204"
COMPANY_WHATSAPP="00966558828009"
COMPANY_WEBSITE="https://deltastars-ksa.com/ar/#contact-us"
COMPANY_MAP="https://maps.app.goo.gl/ZHoiZKmkuj4no2vg8"

# Database credentials (default - change in secrets.env after first run)
POSTGRES_DB="deltastars_db"
POSTGRES_USER="deltastars_user"
POSTGRES_PASSWORD="Deltastars@2025"

# Bank config: **ضع القيم الحقيقية لاحقًا في secrets.env**
BANK_NAME="AlarabiBank"
BANK_BRANCH="Rehab"
BANK_ACCOUNT=""
BANK_IBAN=""

# PWA info
PWA_SHORT_NAME="Deltastars"
PWA_NAME="Deltastars Store"

# ---------- END CONFIG -------------------------------------------------

ROOT="$(pwd)/Deltastars_project"
BACKEND_DIR="$ROOT/backend"
FRONTEND_DIR="$ROOT/frontend"
DATA_DIR="$ROOT/data/products"
DOCS_DIR="$BACKEND_DIR/docs/secure"
NGINX_DIR="$ROOT/nginx"
CERTS_DIR="$ROOT/certs"
LOGS_DIR="$ROOT/logs"

echo ">>> إنشاء بنية المشروع في: $ROOT"
mkdir -p "$BACKEND_DIR" "$FRONTEND_DIR" "$DATA_DIR" "$DOCS_DIR" "$NGINX_DIR" "$CERTS_DIR" "$LOGS_DIR"

# ---------- create secrets.env.example ----------
cat > "$ROOT/secrets.env.example" <<ENV
# COPY this file to secrets.env and edit sensitive values
DJANGO_SECRET_KEY=please-change-me
DJANGO_DEBUG=False
DJANGO_ALLOWED_HOSTS=$DOMAIN,localhost,127.0.0.1

POSTGRES_DB=$POSTGRES_DB
POSTGRES_USER=$POSTGRES_USER
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
POSTGRES_HOST=db
POSTGRES_PORT=5432

ADMIN1_EMAIL=$ADMIN1_EMAIL
ADMIN1_PASS=$ADMIN1_PASS
ADMIN2_EMAIL=$ADMIN2_EMAIL
ADMIN2_PASS=$ADMIN2_PASS

BANK_NAME=$BANK_NAME
BANK_BRANCH=$BANK_BRANCH
BANK_ACCOUNT=$BANK_ACCOUNT
BANK_IBAN=$BANK_IBAN

COMPANY_EMAIL=$COMPANY_EMAIL
COMPANY_PHONE=$COMPANY_PHONE
COMPANY_WHATSAPP=$COMPANY_WHATSAPP
COMPANY_WEBSITE=$COMPANY_WEBSITE
COMPANY_MAP=$COMPANY_MAP

# Links to product file (optional - can leave empty and copy file to data/products)
PRODUCTS_GDRIVE_LINK=$GDRIVE_PRODUCTS_LINK

ENV

echo "ملف مثال secrets.env.example تم إنشاؤه في: $ROOT/secrets.env.example"
echo "⚠️ أنصح بنسخ الملف إلى secrets.env وتعديل القيم الحساسة قبل التشغيل الفعلي."

# ---------- Download product file and docs ----------
echo ">>> تنزيل كشف المنتجات وملفات الوثائق (إذا أمكن)..."
if command -v curl >/dev/null 2>&1; then
  echo "- تنزيل ملف المنتجات إلى $DATA_DIR/products.xlsx"
  curl -L -o "$DATA_DIR/products.xlsx" "$GDRIVE_PRODUCTS_LINK" || echo "تحذير: لم يتم تنزيل ملف المنتجات تلقائيًا. ضع الملف يدوياً في $DATA_DIR"
  echo "- تنزيل المستندات الرسمية إلى $DOCS_DIR"
  curl -L -o "$DOCS_DIR/manager_id.pdf" "$GDRIVE_MANAGER_ID_LINK" || true
  curl -L -o "$DOCS_DIR/trade_license.pdf" "$GDRIVE_TRADE_LICENSE_LINK" || true
  curl -L -o "$DOCS_DIR/tax_number.pdf" "$GDRIVE_TAX_LINK" || true
else
  echo "curl غير متوفر - ضع الملفات يدوياً في $DATA_DIR و $DOCS_DIR"
fi

# ---------- Backend (Django) skeleton ----------
echo ">>> إنشاء هيكل Backend (Django) الأساسي..."
cat > "$BACKEND_DIR/requirements.txt" <<REQ
Django>=4.2
djangorestframework
psycopg2-binary
django-cors-headers
gunicorn
python-dotenv
pandas
openpyxl
REQ

cat > "$BACKEND_DIR/Dockerfile" <<DOCKB
FROM python:3.11-slim
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
WORKDIR /code
COPY requirements.txt /code/
RUN pip install --upgrade pip && pip install -r requirements.txt
COPY . /code/
CMD ["gunicorn", "core.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]
DOCKB

# manage.py
cat > "$BACKEND_DIR/manage.py" <<MG
#!/usr/bin/env python
import os, sys
if __name__ == "__main__":
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")
    from django.core.management import execute_from_command_line
    execute_from_command_line(sys.argv)
MG
chmod +x "$BACKEND_DIR/manage.py"

# core package
mkdir -p "$BACKEND_DIR/core"
cat > "$BACKEND_DIR/core/__init__.py" <<PY
# core package
PY

cat > "$BACKEND_DIR/core/settings.py" <<'SETT'
import os
from pathlib import Path
from dotenv import load_dotenv
load_dotenv(dotenv_path=Path(__file__).resolve().parent.parent.parent / 'secrets.env')
BASE_DIR = Path(__file__).resolve().parent.parent
SECRET_KEY = os.getenv("DJANGO_SECRET_KEY", "please-change-me")
DEBUG = os.getenv("DJANGO_DEBUG", "False") == "True"
ALLOWED_HOSTS = os.getenv("DJANGO_ALLOWED_HOSTS","127.0.0.1,localhost").split(",")
INSTALLED_APPS = [
    "django.contrib.admin","django.contrib.auth","django.contrib.contenttypes",
    "django.contrib.sessions","django.contrib.messages","django.contrib.staticfiles",
    "rest_framework","corsheaders","products","customers"
]
MIDDLEWARE = [
    "corsheaders.middleware.CorsMiddleware","django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware","django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware","django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
]
ROOT_URLCONF = "core.urls"
WSGI_APPLICATION = "core.wsgi.application"
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": os.getenv('POSTGRES_DB','deltastars_db'),
        "USER": os.getenv('POSTGRES_USER','deltastars_user'),
        "PASSWORD": os.getenv('POSTGRES_PASSWORD','Deltastars@2025'),
        "HOST": os.getenv('POSTGRES_HOST','db'),
        "PORT": os.getenv('POSTGRES_PORT','5432'),
    }
}
LANGUAGE_CODE = "ar-SA"
TIME_ZONE = "Asia/Riyadh"
USE_I18N = True
USE_TZ = True
STATIC_URL = "/static/"
STATIC_ROOT = BASE_DIR / "staticfiles"
CORS_ALLOW_ALL_ORIGINS = True
AUTH_USER_MODEL = "customers.User"
SETT

cat > "$BACKEND_DIR/core/urls.py" <<PYU
from django.contrib import admin
from django.urls import path, include
urlpatterns = [
    path('admin/', admin.site.urls),
]
PYU

cat > "$BACKEND_DIR/core/wsgi.py" <<PYW
import os
from django.core.wsgi import get_wsgi_application
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')
application = get_wsgi_application()
PYW

# ---------- apps: products & customers ----------
echo ">>> إنشاء تطبيقات products و customers وموديلاتها..."
mkdir -p "$BACKEND_DIR/products/management/commands" "$BACKEND_DIR/products/migrations"
mkdir -p "$BACKEND_DIR/customers/migrations"

# products models
cat > "$BACKEND_DIR/products/models.py" <<PM
from django.db import models
class Category(models.Model):
    name = models.CharField(max_length=200)
    parent = models.ForeignKey('self', null=True, blank=True, on_delete=models.CASCADE)
class Product(models.Model):
    sku = models.CharField(max_length=100, blank=True, null=True)
    name = models.CharField(max_length=255)
    category = models.CharField(max_length=255, blank=True, null=True)
    price = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    stock = models.IntegerField(default=0)
    image_url = models.CharField(max_length=1000, blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    def __str__(self):
        return self.name
PM

# customers models (custom user for VIP isolation)
cat > "$BACKEND_DIR/customers/models.py" <<CM
from django.contrib.auth.models import AbstractUser
from django.db import models
class User(AbstractUser):
    phone = models.CharField(max_length=30, blank=True, null=True)
    is_vip = models.BooleanField(default=False)
    balance = models.DecimalField(max_digits=12, decimal_places=2, default=0)
    # biometric placeholder (store hash or key)
    biometric_key = models.CharField(max_length=512, blank=True, null=True)
    def __str__(self):
        return self.username
CM

# admin registration
cat > "$BACKEND_DIR/customers/admin.py" <<CUSTADM
from django.contrib import admin
from .models import User
admin.site.register(User)
CUSTADM

cat > "$BACKEND_DIR/products/admin.py" <<PRODADM
from django.contrib import admin
from .models import Product, Category
admin.site.register(Product)
admin.site.register(Category)
PRODADM

# serializers & viewset for products
cat > "$BACKEND_DIR/products/serializers.py" <<PS
from rest_framework import serializers
from .models import Product
class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = '__all__'
PS

cat > "$BACKEND_DIR/products/views.py" <<PV
from rest_framework import viewsets, permissions
from .models import Product
from .serializers import ProductSerializer
class ProductViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.filter(is_active=True)
    serializer_class = ProductSerializer
    permission_classes = [permissions.AllowAny]
PV

# append API router to core.urls
cat >> "$BACKEND_DIR/core/urls.py" <<URLAP
from rest_framework import routers
from products.views import ProductViewSet
router = routers.DefaultRouter()
router.register(r'api/products', ProductViewSet, basename='products')
urlpatterns += router.urls
URLAP

# ---------- management command to import products ----------
cat > "$BACKEND_DIR/products/management/commands/import_products.py" <<IMP
import os, pandas as pd
from django.core.management.base import BaseCommand
from products.models import Product

class Command(BaseCommand):
    help = 'Import products from Excel files located in data/products'

    def handle(self, *args, **options):
        data_dir = os.path.join(os.getcwd(), 'data', 'products')
        files = [f for f in os.listdir(data_dir) if f.endswith('.xlsx') or f.endswith('.csv')]
        if not files:
            self.stdout.write(self.style.ERROR('No product files found in data/products'))
            return
        for f in files:
            path = os.path.join(data_dir, f)
            self.stdout.write(f'Importing: {path}')
            try:
                if path.lower().endswith('.csv'):
                    df = pd.read_csv(path)
                else:
                    df = pd.read_excel(path)
            except Exception as e:
                self.stdout.write(self.style.ERROR(f'Error reading {path}: {e}'))
                continue
            for idx, row in df.iterrows():
                sku = row.get('رقم') or row.get('sku') or ''
                name = row.get('الاسم') or row.get('Name') or 'Unnamed'
                category = row.get('الصنف') or row.get('Category') or ''
                price = row.get('السعر') or row.get('Price') or 0
                image = row.get('صورة') or row.get('Image') or ''
                desc = row.get('الوصف') or row.get('Description') or ''
                product, created = Product.objects.update_or_create(
                    name=name,
                    defaults={'sku':sku,'category':category,'price':price,'stock':0,'image_url':image,'description':desc,'is_active':True}
                )
                if created:
                    self.stdout.write(self.style.SUCCESS(f'Created {name}'))
                else:
                    self.stdout.write(self.style.WARNING(f'Updated {name}'))
        self.stdout.write(self.style.SUCCESS('Import finished.'))
IMP

# ---------- backend .env template (already created secrets.example) ----------
cat > "$BACKEND_DIR/.env" <<ENV
DJANGO_SECRET_KEY=please-change-me
DJANGO_DEBUG=True
DJANGO_ALLOWED_HOSTS=$DOMAIN,localhost,127.0.0.1
POSTGRES_DB=$POSTGRES_DB
POSTGRES_USER=$POSTGRES_USER
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
POSTGRES_HOST=db
POSTGRES_PORT=5432
ENV

# ---------- Frontend: minimal PWA and assets (Arabic-first) ----------
echo ">>> إعداد واجهة Frontend (PWA placeholders + أيقونات وملفات التواصل)..."

cat > "$FRONTEND_DIR/package.json" <<FPKG
{
  "name": "deltastars-frontend",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "start": "serve -s build -l 3000",
    "build": "echo 'React build placeholder - replace with your real build scripts'"
  },
  "dependencies": {
    "serve": "^14.2.0"
  }
}
FPKG

mkdir -p "$FRONTEND_DIR/public/icons"
# create placeholder icons (you should replace with real logos)
for size in 192 512; do
  convert -size ${size}x${size} canvas:none -background none "$FRONTEND_DIR/public/icons/icon-${size}.png" 2>/dev/null || touch "$FRONTEND_DIR/public/icons/icon-${size}.png"
done

cat > "$FRONTEND_DIR/public/manifest.json" <<MAN
{
  "short_name": "$PWA_SHORT_NAME",
  "name": "$PWA_NAME",
  "start_url": "/",
  "display": "standalone",
  "theme_color": "#0b74de",
  "background_color": "#ffffff",
  "icons": [
    { "src": "/icons/icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/icons/icon-512.png", "sizes": "512x512", "type": "image/png" }
  ]
}
MAN

cat > "$FRONTEND_DIR/public/service-worker.js" <<SW
self.addEventListener('install', function(e){ console.log('Service Worker installed'); });
SW

cat > "$FRONTEND_DIR/public/index.html" <<IDX
<!doctype html>
<html lang="ar">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="manifest" href="/manifest.json" />
  <title>Deltastars - المتجر</title>
</head>
<body>
  <div id="root">
    <header>
      <h1>دلتا ستارز - Deltastars</h1>
      <p>اتصل بنا: $COMPANY_PHONE - واتساب: $COMPANY_WHATSAPP</p>
    </header>
    <main>
      <p>واجهة المتجر قيد الإنشاء — سيتم عرض المنتجات المستوردة هنا (عربي أولاً).</p>
    </main>
    <footer>
      <p>البريد: $COMPANY_EMAIL | الموقع: <a href="$COMPANY_WEBSITE">موقع الشركة</a></p>
      <p><a href="$COMPANY_MAP">موقع الخريطة</a></p>
    </footer>
  </div>
</body>
</html>
IDX

# ---------- Nginx config + self-signed SSL (local testing) ----------
cat > "$NGINX_DIR/nginx.conf" <<NGC
user  nginx;
worker_processes  auto;
events { worker_connections 1024; }
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout 65;
    upstream frontend { server frontend:80; }
    upstream backend { server backend:8000; }
    server {
        listen 80;
        server_name _;
        return 301 https://\$host\$request_uri;
    }
    server {
        listen 443 ssl;
        server_name _;
        ssl_certificate /etc/nginx/certs/fullchain.pem;
        ssl_certificate_key /etc/nginx/certs/privkey.pem;
        location / {
            proxy_pass http://frontend;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
        }
        location /api/ {
            proxy_pass http://backend;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
        }
        location /admin/ {
            proxy_pass http://backend;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
        }
    }
}
NGC

# generate self-signed certs (if absent)
if [ ! -f "$CERTS_DIR/privkey.pem" ]; then
  echo ">>> توليد شهادة SSL محلية (self-signed) للصلاحية المحلية..."
  openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
    -keyout "$CERTS_DIR/privkey.pem" -out "$CERTS_DIR/fullchain.pem" \
    -subj "/C=SA/ST=Riyadh/L=Riyadh/O=Deltastars/OU=IT/CN=$DOMAIN"
  chmod 600 "$CERTS_DIR/privkey.pem" "$CERTS_DIR/fullchain.pem"
fi

# ---------- docker-compose.yml ----------
cat > "$ROOT/docker-compose.yml" <<DC
version: '3.8'
services:
  db:
    image: postgres:15
    restart: always
    environment:
      POSTGRES_DB: $POSTGRES_DB
      POSTGRES_USER: $POSTGRES_USER
      POSTGRES_PASSWORD: $POSTGRES_PASSWORD
    volumes:
      - db_data:/var/lib/postgresql/data
    networks:
      - deltanet

  backend:
    build:
      context: ./backend
    restart: always
    env_file:
      - ./secrets.env
    volumes:
      - ./backend:/code
      - ./data:/data
    depends_on:
      - db
    expose:
      - "8000"
    networks:
      - deltanet

  frontend:
    build:
      context: ./frontend
    restart: always
    networks:
      - deltanet
    expose:
      - "80"

  nginx:
    image: nginx:stable-alpine
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./frontend/build:/usr/share/nginx/html:ro
      - ./certs:/etc/nginx/certs:ro
      - ./logs:/var/log/nginx
    ports:
      - "80:80"
      - "443:443"
    depends_on:
      - frontend
      - backend
    networks:
      - deltanet

volumes:
  db_data:

networks:
  deltanet:
    driver: bridge
DC

# ---------- payment_settings (internal banking config) ----------
cat > "$BACKEND_DIR/payment_settings.py" <<PAY
import os
from dotenv import load_dotenv
from pathlib import Path
load_dotenv(dotenv_path=Path(__file__).resolve().parent.parent / 'secrets.env')

BANK_NAME = os.getenv('BANK_NAME', '')
BANK_BRANCH = os.getenv('BANK_BRANCH', '')
BANK_ACCOUNT = os.getenv('BANK_ACCOUNT', '')
BANK_IBAN = os.getenv('BANK_IBAN', '')
PAY

# ---------- Final: build & run ----------
echo ">>> جاهز للتشغيل. قبل المتابعة: انسخ secrets.env.example إلى secrets.env وعدّل القيم الحساسة (POSTGRES_PASSWORD, BANK_ACCOUNT, BANK_IBAN, ADMIN passwords)."
if [ ! -f "$ROOT/secrets.env" ]; then
  cp "$ROOT/secrets.env.example" "$ROOT/secrets.env"
  echo "نسخة من secrets.env.example وضعت في $ROOT/secrets.env — عدّلها الآن ثم أعد تشغيل السكريبت أو استمر."
fi

echo ">> الآن سنبني الحاويات ونعمل تشغيل مبدئي (docker compose up --build -d). تأكد أن لديك Docker و docker-compose مثبتين."

# build & run
cd "$ROOT"
docker compose up --build -d

echo ">>> انتظر 10 ثواني لبدء الحاويات..."
sleep 10

# run migrations & create admins & import products
echo ">>> تشغيل ترحيلات Django وتهيئة المشرفين واستيراد المنتجات..."
docker compose exec backend bash -lc "python manage.py makemigrations --noinput || true; python manage.py migrate --noinput"
# create admins
docker compose exec backend bash -lc "python - <<PY
from django.contrib.auth import get_user_model
User = get_user_model()
import os
admin1 = os.getenv('ADMIN1_EMAIL','${ADMIN1_EMAIL}')
admin1p = os.getenv('ADMIN1_PASS','${ADMIN1_PASS}')
admin2 = os.getenv('ADMIN2_EMAIL','${ADMIN2_EMAIL}')
admin2p = os.getenv('ADMIN2_PASS','${ADMIN2_PASS}')
if not User.objects.filter(username=admin1).exists():
    User.objects.create_superuser(admin1, admin1, admin1p)
    print('Created admin:', admin1)
else:
    print('Admin exists:', admin1)
if not User.objects.filter(username=admin2).exists():
    User.objects.create_superuser(admin2, admin2, admin2p)
    print('Created admin:', admin2)
else:
    print('Admin exists:', admin2)
PY"

# import products
docker compose exec backend bash -lc "python manage.py import_products || true"
# collectstatic
docker compose exec backend bash -lc "python manage.py collectstatic --noinput || true"

echo "✅ انتهى الإعداد التلقائي. تحقق من الخطوات التالية."

cat <<CHECK

=======================================
Verification CHECKLIST - قائمة التحقق
=======================================
1) أضف السطر التالي إلى ملف hosts محليًا (/etc/hosts):
   127.0.0.1 $DOMAIN

2) افتح المتصفح واذهب إلى:
   https://$DOMAIN
   - قد تحتاج لقبول الشهادة الذاتية (self-signed) مرة واحدة.

3) لوحة الإدارة:
   https://$DOMAIN/admin/
   - Admin users: $ADMIN1_EMAIL  و  $ADMIN2_EMAIL
   - استخدم كلمات المرور من secrets.env

4) API المنتجات:
   https://$DOMAIN/api/products/

5) تثبيت كـ PWA:
   - افتح الموقع على هاتف Android ثم اختر "Add to Home screen".

6) تحقق من استيراد المنتجات:
   - في Django Admin > Products، يجب أن ترى ~91 منتجاً (حسب كشفك)

7) الدفع البنكي:
   - بيانات الحساب البنكي محفوظة في backend/payment_settings.py وتُستخدم داخليًا عند إنشاء إشعارات الدفع اليدوي.

Security Notes:
- احذف أو خزّن الوثائق الحساسة في مكان آمن بعد الانتهاء.
- استخدم شهادة صادرة عن CA (Let's Encrypt) عند الإطلاق الرسمي.
- فكر في استخدام Vault أو Secrets Manager لتخزين بيانات البنك.
=======================================
CHECK

echo "تم. إن واجهت أي خطأ أرسل مخرجات الأمر 'docker compose ps' و 'docker compose logs backend' لأساعدك بالتصحيح."