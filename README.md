DeltaStars-FullStack/
├── 📱 mobile-app/
│   ├── src/
│   │   ├── components/
│   │   ├── screens/
│   │   ├── navigation/
│   │   ├── redux/
│   │   ├── services/
│   │   └── utils/
│   ├── assets/
│   ├── package.json
│   └── app.json
├── 🖥️ web-dashboard/
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── layouts/
│   │   ├── services/
│   │   └── utils/
│   ├── public/
│   └── package.json
├── ⚙️ backend/
│   ├── core/
│   ├── apps/
│   │   ├── users/
│   │   ├── products/
│   │   ├── orders/
│   │   ├── payments/
│   │   └── dashboard/
│   ├── config/
│   └── requirements.txt
└── 📚 documentation/
    ├── setup-guide.md
    ├── deployment.md
    └── api-docs.md
{
  "name": "deltastars-mobile",
  "version": "1.0.0",
  "main": "node_modules/expo/AppEntry.js",
  "scripts": {
    "start": "expo start",
    "android": "expo start --android",
    "ios": "expo start --ios",
    "web": "expo start --web",
    "build": "expo build",
    "build:android": "expo build:android",
    "build:ios": "expo build:ios"
  },
  "dependencies": {
    "react": "18.2.0",
    "react-native": "0.72.6",
    "expo": "~49.0.0",
    "expo-status-bar": "~1.6.0",
    
    // التنقل
    "@react-navigation/native": "^6.1.0",
    "@react-navigation/stack": "^6.3.0",
    "@react-navigation/bottom-tabs": "^6.5.0",
    "react-native-screens": "~3.22.0",
    "react-native-safe-area-context": "4.6.0",
    
    // إدارة الحالة
    "@reduxjs/toolkit": "^1.9.0",
    "react-redux": "^8.0.0",
    "redux-persist": "^6.0.0",
    
    // الطلبات الشبكية
    "axios": "^1.5.0",
    
    // التخزين المحلي
    "@react-native-async-storage/async-storage": "1.18.0",
    
    // الترجمة
    "i18n-js": "^3.9.0",
    "react-i18next": "^13.0.0",
    
    // الواجهات
    "react-native-vector-icons": "^10.0.0",
    "react-native-gesture-handler": "~2.12.0",
    "react-native-reanimated": "~3.3.0",
    
    // الدفع والإشعارات
    "react-native-push-notification": "^8.1.1",
    "react-native-webview": "^13.2.0",
    
    // التاريخ الهجري
    "hijri-converter": "^1.0.2",
    
    // التحليلات
    "react-native-chart-kit": "^6.12.0"
  },
  "devDependencies": {
    "@babel/core": "^7.20.0"
  }
}
import React from 'react';
import { Provider } from 'react-redux';
import { NavigationContainer } from '@react-navigation/native';
import { PersistGate } from 'redux-persist/integration/react';
import { StatusBar } from 'react-native';
import store, { persistor } from './src/redux/store';
import AppNavigator from './src/navigation/AppNavigator';
import { I18nProvider } from './src/utils/i18n';
import { NotificationProvider } from './src/services/notifications';

const App = () => {
  return (
    <Provider store={store}>
      <PersistGate loading={null} persistor={persistor}>
        <I18nProvider>
          <NotificationProvider>
            <NavigationContainer>
              <StatusBar 
                barStyle="dark-content" 
                backgroundColor="#ffffff" 
                translucent={false}
              />
              <AppNavigator />
            </NavigationContainer>
          </NotificationProvider>
        </I18nProvider>
      </PersistGate>
    </Provider>
  );
};

export default App;
import { I18n } from 'i18n-js';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { ar, en } from './translations';

const i18n = new I18n({ ar, en });

i18n.defaultLocale = 'ar';
i18n.locale = 'ar';
i18n.enableFallback = true;

export const translations = {
  ar: {
    welcome: "مرحباً بك في نجوم دلتا",
    products: "المنتجات",
    categories: "الفئات",
    cart: "السلة",
    profile: "الملف الشخصي",
    login: "تسجيل الدخول",
    register: "إنشاء حساب",
    logout: "تسجيل الخروج",
    search: "ابحث عن المنتجات...",
    addToCart: "أضف إلى السلة",
    price: "السعر",
    quantity: "الكمية",
    total: "الإجمالي",
    checkout: "إتمام الطلب",
    continueShopping: "مواصلة التسوق",
    emptyCart: "سلة التسوق فارغة",
    orderSuccess: "تم تقديم الطلب بنجاح!",
    freshProduce: "فواكه وخضروات طازجة",
    qualityGuarantee: "ضمان الجودة",
    fastDelivery: "توصيل سريع",
    customerSupport: "دعم العملاء",
    // ... المزيد من الترجمات
  },
  en: {
    welcome: "Welcome to Delta Stars",
    products: "Products",
    categories: "Categories",
    cart: "Cart",
    profile: "Profile",
    login: "Login",
    register: "Register",
    logout: "Logout",
    search: "Search products...",
    addToCart: "Add to Cart",
    price: "Price",
    quantity: "Quantity",
    total: "Total",
    checkout: "Checkout",
    continueShopping: "Continue Shopping",
    emptyCart: "Your cart is empty",
    orderSuccess: "Order placed successfully!",
    freshProduce: "Fresh Fruits & Vegetables",
    qualityGuarantee: "Quality Guarantee",
    fastDelivery: "Fast Delivery",
    customerSupport: "Customer Support",
    // ... More translations
  }
};

export default i18n;
import { configureStore } from '@reduxjs/toolkit';
import { persistStore, persistReducer } from 'redux-persist';
import AsyncStorage from '@react-native-async-storage/async-storage';
import authReducer from './slices/authSlice';
import cartReducer from './slices/cartSlice';
import productsReducer from './slices/productsSlice';
import ordersReducer from './slices/ordersSlice';

const persistConfig = {
  key: 'root',
  storage: AsyncStorage,
  whitelist: ['auth', 'cart', 'settings']
};

const rootReducer = {
  auth: persistReducer(persistConfig, authReducer),
  cart: cartReducer,
  products: productsReducer,
  orders: ordersReducer,
  settings: persistReducer(persistConfig, settingsReducer),
};

const store = configureStore({
  reducer: rootReducer,
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: {
        ignoredActions: ['persist/PERSIST'],
      },
    }),
});

export const persistor = persistStore(store);
export default store;
import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  ScrollView,
  TouchableOpacity,
  Image,
  StyleSheet,
  SafeAreaView,
  RefreshControl
} from 'react-native';
import { useDispatch, useSelector } from 'react-redux';
import { useI18n } from '../utils/i18n';
import { fetchProducts } from '../redux/slices/productsSlice';
import ProductGrid from '../components/ProductGrid';
import CategoryList from '../components/CategoryList';
import Header from '../components/Header';
import Loading from '../components/Loading';

const HomeScreen = ({ navigation }) => {
  const { i18n } = useI18n();
  const dispatch = useDispatch();
  const { products, loading } = useSelector(state => state.products);
  const [refreshing, setRefreshing] = useState(false);

  useEffect(() => {
    loadProducts();
  }, []);

  const loadProducts = async () => {
    await dispatch(fetchProducts());
  };

  const onRefresh = async () => {
    setRefreshing(true);
    await loadProducts();
    setRefreshing(false);
  };

  const categories = [
    {
      id: 1,
      name: i18n.t('freshFruits'),
      icon: '🍎',
      count: 45,
      color: '#FF6B6B'
    },
    {
      id: 2,
      name: i18n.t('freshVegetables'),
      icon: '🥦',
      count: 32,
      color: '#51CF66'
    },
    {
      id: 3,
      name: i18n.t('organic'),
      icon: '🌱',
      count: 28,
      color: '#94D82D'
    },
    {
      id: 4,
      name: i18n.t('seasonal'),
      icon: '🎯',
      count: 15,
      color: '#FF922B'
    }
  ];

  if (loading && !refreshing) {
    return <Loading />;
  }

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView 
        showsVerticalScrollIndicator={false}
        refreshControl={
          <RefreshControl refreshing={refreshing} onRefresh={onRefresh} />
        }
      >
        {/* الهيدر */}
        <Header navigation={navigation} />
        
        {/* شريط البحث */}
        <TouchableOpacity 
          style={styles.searchBar}
          onPress={() => navigation.navigate('Search')}
        >
          <Text style={styles.searchText}>{i18n.t('search')}</Text>
          <Text style={styles.searchIcon}>🔍</Text>
        </TouchableOpacity>

        {/* الفئات */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>{i18n.t('categories')}</Text>
          <CategoryList 
            categories={categories}
            onCategoryPress={(category) => 
              navigation.navigate('Products', { category: category.name })
            }
          />
        </View>

        {/* المنتجات المميزة */}
        <View style={styles.section}>
          <View style={styles.sectionHeader}>
            <Text style={styles.sectionTitle}>{i18n.t('featuredProducts')}</Text>
            <TouchableOpacity onPress={() => navigation.navigate('Products')}>
              <Text style={styles.seeAllText}>{i18n.t('seeAll')}</Text>
            </TouchableOpacity>
          </View>
          <ProductGrid 
            products={products.slice(0, 6)}
            onProductPress={(product) => 
              navigation.navigate('ProductDetail', { product })
            }
          />
        </View>

        {/* ضمان الجودة */}
        <View style={styles.qualityCard}>
          <View style={styles.qualityHeader}>
            <Text style={styles.qualityIcon}>🛡️</Text>
            <Text style={styles.qualityTitle}>{i18n.t('qualityGuarantee')}</Text>
          </View>
          <Text style={styles.qualityText}>
            {i18n.t('qualityDescription')}
          </Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f8f9fa',
  },
  searchBar: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    backgroundColor: 'white',
    marginHorizontal: 20,
    marginVertical: 10,
    padding: 15,
    borderRadius: 12,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  searchText: {
    color: '#666',
    fontSize: 16,
  },
  searchIcon: {
    fontSize: 18,
  },
  section: {
    marginVertical: 20,
    paddingHorizontal: 20,
  },
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 15,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#2d5c2d',
  },
  seeAllText: {
    color: '#2d5c2d',
    fontWeight: '600',
  },
  qualityCard: {
    backgroundColor: '#e8f5e8',
    margin: 20,
    padding: 20,
    borderRadius: 12,
    borderLeftWidth: 4,
    borderLeftColor: '#2d5c2d',
  },
  qualityHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
  },
  qualityIcon: {
    fontSize: 24,
    marginRight: 10,
  },
  qualityTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#2d5c2d',
  },
  qualityText: {
    fontSize: 14,
    color: '#666',
    lineHeight: 20,
  },
});

export default HomeScreen;
import React from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  Image,
  StyleSheet,
  Alert
} from 'react-native';
import { useDispatch } from 'react-redux';
import { useI18n } from '../utils/i18n';
import { addToCart } from '../redux/slices/cartSlice';

const ProductCard = ({ product, onPress }) => {
  const { i18n } = useI18n();
  const dispatch = useDispatch();

  const handleAddToCart = () => {
    dispatch(addToCart({
      ...product,
      quantity: 1
    }));
    
    Alert.alert(
      i18n.t('success'),
      `${i18n.t('addedToCart')} ${product.name}`,
      [{ text: i18n.t('ok') }]
    );
  };

  return (
    <TouchableOpacity 
      style={styles.card}
      onPress={onPress}
      activeOpacity={0.8}
    >
      <View style={styles.imageContainer}>
        <Image 
          source={{ uri: product.images[0] }} 
          style={styles.image}
          defaultSource={require('../../assets/images/placeholder.png')}
        />
        {product.discount > 0 && (
          <View style={styles.discountBadge}>
            <Text style={styles.discountText}>
              {product.discount}%
            </Text>
          </View>
        )}
      </View>

      <View style={styles.info}>
        <Text style={styles.category} numberOfLines={1}>
          {product.category}
        </Text>
        <Text style={styles.name} numberOfLines={2}>
          {product.name}
        </Text>
        
        <View style={styles.weight}>
          <Text style={styles.weightText}>
            {product.weight}
          </Text>
        </View>

        <View style={styles.footer}>
          <View style={styles.priceContainer}>
            {product.originalPrice > product.price && (
              <Text style={styles.originalPrice}>
                {product.originalPrice} {i18n.t('currency')}
              </Text>
            )}
            <Text style={styles.price}>
              {product.price} {i18n.t('currency')}
            </Text>
          </View>
          
          <TouchableOpacity 
            style={styles.addButton}
            onPress={handleAddToCart}
          >
            <Text style={styles.addButtonText}>+</Text>
          </TouchableOpacity>
        </View>
      </View>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  card: {
    backgroundColor: 'white',
    borderRadius: 12,
    marginBottom: 15,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
    overflow: 'hidden',
  },
  imageContainer: {
    position: 'relative',
  },
  image: {
    width: '100%',
    height: 150,
    resizeMode: 'cover',
  },
  discountBadge: {
    position: 'absolute',
    top: 10,
    left: 10,
    backgroundColor: '#FF6B6B',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 6,
  },
  discountText: {
    color: 'white',
    fontSize: 12,
    fontWeight: 'bold',
  },
  info: {
    padding: 15,
  },
  category: {
    fontSize: 12,
    color: '#666',
    marginBottom: 4,
  },
  name: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 8,
    lineHeight: 20,
  },
  weight: {
    backgroundColor: '#f8f9fa',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 6,
    alignSelf: 'flex-start',
    marginBottom: 12,
  },
  weightText: {
    fontSize: 12,
    color: '#666',
  },
  footer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  priceContainer: {
    flex: 1,
  },
  originalPrice: {
    fontSize: 12,
    color: '#999',
    textDecorationLine: 'line-through',
    marginBottom: 2,
  },
  price: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#2d5c2d',
  },
  addButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: '#2d5c2d',
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.2,
    shadowRadius: 3,
    elevation: 3,
  },
  addButtonText: {
    color: 'white',
    fontSize: 18,
    fontWeight: 'bold',
  },
});

export default ProductCard;
"""
Django settings for deltastars project.
"""

import os
from pathlib import Path
from datetime import timedelta

BASE_DIR = Path(__file__).resolve().parent.parent

SECRET_KEY = os.environ.get('SECRET_KEY', 'deltastars-secret-key-2024')

DEBUG = os.environ.get('DEBUG', 'True') == 'True'

ALLOWED_HOSTS = ['*']

# Application definition
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    
    # Third party apps
    'rest_framework',
    'rest_framework_simplejwt',
    'corsheaders',
    'drf_yasg',
    'django_filters',
    
    # Local apps
    'apps.users',
    'apps.products',
    'apps.orders',
    'apps.payments',
    'apps.dashboard',
    'apps.notifications',
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'core.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates'],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'core.wsgi.application'

# Database
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('DB_NAME', 'deltastars'),
        'USER': os.environ.get('DB_USER', 'postgres'),
        'PASSWORD': os.environ.get('DB_PASSWORD', 'password'),
        'HOST': os.environ.get('DB_HOST', 'localhost'),
        'PORT': os.environ.get('DB_PORT', '5432'),
    }
}

# REST Framework
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticated',
    ),
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 20,
    'DEFAULT_FILTER_BACKENDS': [
        'django_filters.rest_framework.DjangoFilterBackend',
        'rest_framework.filters.SearchFilter',
        'rest_framework.filters.OrderingFilter',
    ],
}

# JWT Settings
SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(days=7),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=30),
    'ROTATE_REFRESH_TOKENS': True,
    'BLACKLIST_AFTER_ROTATION': True,
}

# CORS Settings
CORS_ALLOW_ALL_ORIGINS = True
CORS_ALLOW_CREDENTIALS = True

# Internationalization
LANGUAGE_CODE = 'ar-sa'
TIME_ZONE = 'Asia/Riyadh'
USE_I18N = True
USE_L10N = True
USE_TZ = True

# Static files
STATIC_URL = '/static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'
MEDIA_URL = '/media/'
MEDIA_ROOT = BASE_DIR / 'media'

# Default primary key field type
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# Custom User Model
AUTH_USER_MODEL = 'users.User'

# Email Configuration
EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = os.environ.get('EMAIL_HOST', 'smtp.gmail.com')
EMAIL_PORT = int(os.environ.get('EMAIL_PORT', 587))
EMAIL_USE_TLS = True
EMAIL_HOST_USER = os.environ.get('EMAIL_HOST_USER', '')
EMAIL_HOST_PASSWORD = os.environ.get('EMAIL_HOST_PASSWORD', '')

# WhatsApp Configuration
WHATSAPP_API_URL = os.environ.get('WHATSAPP_API_URL', '')
WHATSAPP_API_TOKEN = os.environ.get('WHATSAPP_API_TOKEN', '')

# Bank Configuration
BANK_ACCOUNT = {
    'bank_name': 'البنك العربي',
    'branch_number': '0202',
    'branch_name': 'فرع الرحاب',
    'company_name': 'شركة نجوم دلتا للتجارة',
    'id_number': '4030457293',
    'account_number': '0108095516770029',
    'iban': 'SA4730400108095516770029'
}
from django.contrib.auth.models import AbstractUser
from django.db import models
from .managers import UserManager

class User(AbstractUser):
    USER_ROLES = (
        ('super_admin', 'المدير العام'),
        ('admin', 'مدير'),
        ('marketing', 'قسم التسويق'),
        ('monitoring', 'قسم المتابعة'),
        ('developer', 'المطور'),
        ('customer', 'عميل'),
        ('hotel', 'فندق/مؤسسة'),
    )
    
    role = models.CharField(max_length=20, choices=USER_ROLES, default='customer')
    phone = models.CharField(max_length=20, unique=True)
    email = models.EmailField(unique=True)
    company_name = models.CharFiel## Hi there 👋

<!--
**deltastars/Deltastars** is a ✨ _special_ ✨ repository because its `README.md` (this file) appears on your GitHub profile.

Here are some ideas to get you started:

- 🔭 I’m currently working on ...
- 🌱 I’m currently learning ...
- 👯 I’m looking to collaborate on ...
- 🤔 I’m looking for help with ...
- 💬 Ask me about ...
- 📫 How to reach me: ...
- 😄 Pronouns: ...
- ⚡ Fun fact: ...

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
docker compose exec backend bash -lc "python manage.py collectstatic --noinput || t