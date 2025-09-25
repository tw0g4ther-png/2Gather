# Firebase Functions - TwoGather

Ce dossier contient toutes les Firebase Functions pour l'application TwoGather.

## Structure

- `callables/` - Fonctions appelables depuis l'application Flutter
- `trigggers/` - Fonctions déclenchées par des événements Firebase
- `index.ts` - Point d'entrée principal
- `lazy.ts` - Utilitaire pour le chargement paresseux
- `misc.ts` - Fonctions utilitaires

## Fonctions principales

### Gestion des amis
- `addFriend` - Ajouter un ami
- `deleteFriend` - Supprimer un ami
- `confirmFriendRequest` - Confirmer une demande d'ami
- `addFriendWithSwipe` - Ajouter un ami via swipe
- `dismissFriendWithSwipe` - Rejeter un ami via swipe

### Gestion des fiestas
- `joinFiesta` - Rejoindre une fiesta
- `deleteFiesta` - Supprimer une fiesta
- `getFiestaList` - Obtenir la liste des fiestas
- `acceptUserInFiesta` - Accepter un utilisateur dans une fiesta
- `deleteUserInFiesta` - Supprimer un utilisateur d'une fiesta

### Système de duo
- `requestNewLockDuo` - Demander un nouveau duo verrouillé
- `confirmDuoRequest` - Confirmer une demande de duo
- `stopLockDuo` - Arrêter un duo verrouillé
- `requestADuoToGoFiesta` - Demander un duo pour aller en fiesta

### Autres fonctions
- `verifyTrustCode` - Vérifier un code de confiance
- `profilIsCompleted` - Vérifier si le profil est complet
- `getUserCardList` - Obtenir la liste des cartes utilisateur
- `createFiestaPoint` - Créer un point fiesta

## Déploiement

Pour déployer les fonctions :

```bash
cd functions
npm install
npm run build
firebase deploy --only functions
```

## Configuration

Le projet Firebase configuré : `gather-10f2b`
URI des fonctions : `us-central1-gather-10f2b.cloudfunctions.net`
