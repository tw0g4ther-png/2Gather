#!/bin/bash

# Script universel pour reset complet d'un dépôt Git
# Usage: ./git-reset-repo.sh [repository_url] [commit_message] [project_name]

# Avec message personnalisé
#./git-reset-repo.sh -m "21 septembre à 23h27" https://github.com/tw0g4ther-png/2Gather.git

set -e  # Arrêter le script en cas d'erreur

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Fonction pour afficher des messages colorés
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${CYAN}================================${NC}"
    echo -e "${CYAN}  Git Repository Reset Tool${NC}"
    echo -e "${CYAN}================================${NC}"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Fonction d'aide
show_help() {
    echo "Usage: $0 [OPTIONS] [REPOSITORY_URL]"
    echo
    echo "Reset complètement un dépôt Git et pousse un nouveau projet propre."
    echo
    echo "Arguments:"
    echo "  REPOSITORY_URL          URL du dépôt GitHub (ex: https://github.com/user/repo.git)"
    echo
    echo "Options:"
    echo "  -h, --help              Afficher cette aide"
    echo "  -m, --message MESSAGE   Message de commit personnalisé"
    echo "  -p, --project NAME      Nom du projet (auto-détecté si non fourni)"
    echo "  -v, --version VERSION   Version du projet (ex: v1.0.0)"
    echo "  -f, --force             Ne pas demander de confirmation"
    echo "  --dry-run               Simuler les actions sans les exécuter"
    echo
    echo "Exemples:"
    echo "  $0 https://github.com/user/myproject.git"
    echo "  $0 -m \"Fresh start v2.0\" -p MyApp https://github.com/user/myapp.git"
    echo "  $0 --version v1.5.0 --force https://github.com/user/project.git"
    echo
    echo "ATTENTION: Cette opération supprime définitivement l'historique Git existant!"
}

# Variables par défaut
REPOSITORY_URL=""
COMMIT_MESSAGE=""
PROJECT_NAME=""
PROJECT_VERSION=""
FORCE_MODE=false
DRY_RUN=false

# Parser les arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -m|--message)
            COMMIT_MESSAGE="$2"
            shift 2
            ;;
        -p|--project)
            PROJECT_NAME="$2"
            shift 2
            ;;
        -v|--version)
            PROJECT_VERSION="$2"
            shift 2
            ;;
        -f|--force)
            FORCE_MODE=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        https://github.com/*|git@github.com:*)
            REPOSITORY_URL="$1"
            shift
            ;;
        *)
            print_error "Option ou URL inconnue: $1"
            show_help
            exit 1
            ;;
    esac
done

print_header

# Validation de l'URL du dépôt
if [ -z "$REPOSITORY_URL" ]; then
    print_error "URL du dépôt GitHub requise"
    echo
    show_help
    exit 1
fi

# Validation du format de l'URL
if [[ ! "$REPOSITORY_URL" =~ ^https://github\.com/.+/.+\.git$ ]] && [[ ! "$REPOSITORY_URL" =~ ^git@github\.com:.+/.+\.git$ ]]; then
    print_error "Format d'URL invalide. Utilisez: https://github.com/user/repo.git"
    exit 1
fi

# Extraire le nom du projet depuis l'URL si non fourni
if [ -z "$PROJECT_NAME" ]; then
    PROJECT_NAME=$(basename "$REPOSITORY_URL" .git)
    print_message "Nom du projet auto-détecté: $PROJECT_NAME"
fi

# Auto-détecter le type de projet
PROJECT_TYPE="Unknown"
if [ -f "pubspec.yaml" ]; then
    PROJECT_TYPE="Flutter"
elif [ -f "package.json" ]; then
    PROJECT_TYPE="Node.js"
elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    PROJECT_TYPE="Python"
elif [ -f "pom.xml" ]; then
    PROJECT_TYPE="Java/Maven"
elif [ -f "Cargo.toml" ]; then
    PROJECT_TYPE="Rust"
elif [ -f "go.mod" ]; then
    PROJECT_TYPE="Go"
fi

print_message "Type de projet détecté: $PROJECT_TYPE"

# Message de commit par défaut
if [ -z "$COMMIT_MESSAGE" ]; then
    VERSION_SUFFIX=""
    if [ -n "$PROJECT_VERSION" ]; then
        VERSION_SUFFIX=" $PROJECT_VERSION"
    fi
    
    COMMIT_MESSAGE="Fresh start: $PROJECT_NAME$VERSION_SUFFIX

- Projet $PROJECT_TYPE réinitialisé avec historique propre
- Tous les fichiers du projet inclus
- Configuration et dépendances préservées
- Prêt pour développement et déploiement"
fi

# Afficher le résumé des actions
echo
print_step "Résumé des actions à effectuer:"
echo "• Projet: $PROJECT_NAME ($PROJECT_TYPE)"
echo "• Dépôt: $REPOSITORY_URL"
echo "• Message: $(echo "$COMMIT_MESSAGE" | head -n1)"
if [ -n "$PROJECT_VERSION" ]; then
    echo "• Version: $PROJECT_VERSION"
fi
echo

# Demander confirmation si pas en mode force
if [ "$FORCE_MODE" = false ] && [ "$DRY_RUN" = false ]; then
    print_warning "ATTENTION: Cette opération va supprimer définitivement l'historique Git existant!"
    read -p "Voulez-vous continuer ? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_message "Opération annulée"
        exit 0
    fi
fi

# Fonctions d'exécution
execute_command() {
    local cmd="$1"
    local description="$2"
    
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY-RUN] $description: $cmd"
    else
        print_step "$description"
        eval "$cmd"
    fi
}

# Exécution des commandes
echo
print_step "Début du reset du dépôt..."

# 1. Supprimer le dossier .git existant
execute_command "rm -rf .git" "Suppression de l'historique Git existant"

# 2. Initialiser un nouveau dépôt
execute_command "git init" "Initialisation d'un nouveau dépôt Git"

# 3. Configurer la branche principale
execute_command "git branch -M main" "Configuration de la branche principale (main)"

# 4. Ajouter le remote
execute_command "git remote add origin \"$REPOSITORY_URL\"" "Ajout du remote GitHub"

# 5. Ajouter tous les fichiers
execute_command "git add ." "Ajout de tous les fichiers du projet"

# 6. Créer le commit initial
execute_command "git commit -m \"$COMMIT_MESSAGE\"" "Création du commit initial"

# 7. Pousser vers GitHub avec force
execute_command "git push origin main --force" "Push forcé vers GitHub (écrase l'historique distant)"

# Résumé final
if [ "$DRY_RUN" = false ]; then
    echo
    print_message "✅ Reset du dépôt terminé avec succès !"
    echo
    echo -e "${BLUE}Résumé:${NC}"
    echo "• Historique Git complètement réinitialisé"
    echo "• Nouveau commit initial créé: $(git log --oneline -1)"
    echo "• Projet poussé vers: $REPOSITORY_URL"
    echo "• Tous les fichiers du projet préservés"
    echo
    echo -e "${BLUE}Le dépôt est maintenant propre et prêt à l'emploi ! 🚀${NC}"
else
    echo
    print_message "Mode simulation terminé. Utilisez sans --dry-run pour exécuter réellement."
fi
