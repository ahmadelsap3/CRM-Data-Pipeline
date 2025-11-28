#!/bin/bash

# GitHub Push Script for ELT-Engine Project
# Usage: ./push_to_github.sh YOUR_GITHUB_USERNAME

set -e

echo "🚀 GitHub Push Script for ELT-Engine"
echo "====================================="
echo ""

# Check if username is provided
if [ -z "$1" ]; then
    echo "❌ Error: GitHub username not provided"
    echo ""
    echo "Usage: ./push_to_github.sh YOUR_GITHUB_USERNAME"
    echo ""
    echo "Example: ./push_to_github.sh ahmed-elsaba"
    exit 1
fi

GITHUB_USERNAME=$1
REPO_NAME="ELT-Engine-ITI"
REPO_URL="https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"

echo "📋 Configuration:"
echo "  GitHub Username: $GITHUB_USERNAME"
echo "  Repository Name: $REPO_NAME"
echo "  Repository URL: $REPO_URL"
echo ""

# Check if we're in the right directory
if [ ! -d ".git" ]; then
    echo "❌ Error: Not in a git repository!"
    echo "Please run this script from the ELT-Engine directory"
    exit 1
fi

# Check if remote already exists
if git remote | grep -q "^origin$"; then
    echo "⚠️  Remote 'origin' already exists"
    echo "Current remote URL:"
    git remote get-url origin
    echo ""
    read -p "Do you want to update it? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🔧 Updating remote URL..."
        git remote set-url origin "$REPO_URL"
        echo "✅ Remote URL updated"
    else
        echo "❌ Cancelled"
        exit 1
    fi
else
    echo "🔧 Adding remote 'origin'..."
    git remote add origin "$REPO_URL"
    echo "✅ Remote added"
fi

echo ""
echo "📊 Current git status:"
git status --short
echo ""

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "⚠️  You have uncommitted changes!"
    echo ""
    read -p "Do you want to commit them first? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add -A
        echo "Commit message:"
        read -p "> " commit_msg
        git commit -m "$commit_msg"
        echo "✅ Changes committed"
    fi
fi

echo ""
echo "🔄 Renaming branch to 'main'..."
git branch -M main
echo "✅ Branch renamed to 'main'"

echo ""
echo "📤 Pushing to GitHub..."
echo "Repository: $REPO_URL"
echo ""

# Push to GitHub
if git push -u origin main; then
    echo ""
    echo "✅ Successfully pushed to GitHub!"
    echo ""
    echo "🎉 Your repository is now available at:"
    echo "   https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
    echo ""
    echo "📋 Next steps:"
    echo "   1. Visit your repository on GitHub"
    echo "   2. Verify all files are present"
    echo "   3. Check that secrets.env is NOT visible (should be excluded)"
    echo "   4. Add Karim Yasser as a collaborator"
    echo "   5. Add repository topics: data-engineering, elt, snowflake, airflow, dbt"
    echo ""
else
    echo ""
    echo "❌ Push failed!"
    echo ""
    echo "Common issues:"
    echo "  1. Repository doesn't exist on GitHub yet"
    echo "     → Create it at: https://github.com/new"
    echo ""
    echo "  2. Authentication failed"
    echo "     → You may need to use a Personal Access Token"
    echo "     → Create one at: https://github.com/settings/tokens"
    echo "     → Use token as password when prompted"
    echo ""
    echo "  3. Wrong repository URL"
    echo "     → Check your GitHub username: $GITHUB_USERNAME"
    echo "     → Verify repository name: $REPO_NAME"
    echo ""
    exit 1
fi
