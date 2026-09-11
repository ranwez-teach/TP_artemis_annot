# TP Artemis dans GitHub Codespaces

Ce depot contient un environnement Codespaces minimal pour lancer Artemis dans un
bureau web noVNC. Les etudiants n'ont rien a installer localement : GitHub cree le
conteneur, expose un bureau leger sur le port `6080`, puis le script de demarrage
ouvre Artemis avec un fichier d'exemple.

## Demarrage rapide

1. Ouvrir ce depot sur GitHub.
2. Cliquer sur **Code > Codespaces > Create codespace on main**.
3. Attendre la fin de la creation du conteneur.
4. Ouvrir le port **6080 - Artemis desktop** quand Codespaces le propose.

Artemis est lance automatiquement par `start-artemis.sh`. Les logs sont disponibles
dans le Codespace :

```bash
cat /tmp/artemis.log
```

## Fichiers du TP

Les donnees sont dans `data/`. Le fichier ouvert par defaut est :

```text
data/example.embl
```

Pour ouvrir un autre fichier pendant une seance, deposez-le dans `data/`, puis
relancez Artemis depuis le terminal du Codespace :

```bash
pkill -f artemis.jar || true
bash start-artemis.sh data/votre-fichier.embl
```

## Version Artemis

L'image installe l'archive UNIX officielle :

```text
Artemis 18.2.0
```

La version se modifie dans `.devcontainer/Dockerfile` via l'argument
`ARTEMIS_VERSION`.

## Verification dans le Codespace

Une fois le Codespace cree, cette commande permet de verifier rapidement que
l'installation Artemis est presente :

```bash
bash scripts/check-artemis-install.sh
```

## Notes pratiques pour un TP

- Chaque etudiant consomme un Codespace GitHub distinct.
- Le port `6080` donne acces au bureau Fluxbox/noVNC.
- Si Artemis ne s'affiche pas tout de suite, consultez `/tmp/artemis.log`.
- Pour remplacer le jeu d'exemple, ajoutez vos fichiers EMBL, GenBank, FASTA ou GFF
  dans `data/`.
