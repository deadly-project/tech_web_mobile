# GESTION DE NOTIFICATION DE PANNE ET ANOMALIES RESEAU

Stack utilisé : Flutter + Node js + Postgresql

## 🚀 Installation et Configuration

### 1. Prérequis
* **Node.js** : `v22.16.0` ou supérieur
* **Flutter SDK** : [Documentation d'installation](https://docs.flutter.dev/install/manual)
* **PostgreSQL** : [Télécharger PostgreSQL](https://www.postgresql.org/download/)


Installation de node et ses des dépendances de node js 💻
```bash
cd serveur
npm install
```
Installation des dependance de flutter 📱
```bash
cd frontend/flutter_application_1/
flutter clean
flutter pub get
```

Crée le fichier de configutaion .env dans le dossier root du backend :conf
```bash
cd serveur
touch .env
```

** Inserer ces données de votre choix dans le fichier .env **
```
POSTGRES_USER=votre_utilisateur_postgres  
POSTGRES_PASSWORD=votre_mot_de_passe_postgres  
POSTRES_DB=votre_base_de_donnée  
PORT=3000  

#Pour_le_hashage  
SECRET_KEY="votre_secret_key"  
DEFAULT_ADMIN_USERNAME=username_admin  
DEFAULT_ADMIN_EMAIL=votre_email_admin@gmail.com  
DEFAULT_ADMIN_PASSWORD=password_admin  
```

Pour lancer le projet  🚀
Lancer le frontend dans le dossier frontend/flutter_application_1
```bash
flutter run
```
Lancer le serveur dans le dossier serveur/ 🚀
```
npm start
```
