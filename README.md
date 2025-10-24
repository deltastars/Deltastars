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
-->
