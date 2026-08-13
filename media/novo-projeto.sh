#!/usr/bin/env bash
# Cria a pasta de um empreendimento a partir de _modelo/
# uso: ./novo-projeto.sh quinta-do-lago
set -euo pipefail

cd "$(dirname "$0")"

slug="${1:-}"
if [ -z "$slug" ]; then
  echo "uso: ./novo-projeto.sh <slug>"
  echo "     slug = minúsculas, sem acentos, com hífens. ex: quinta-do-lago"
  exit 1
fi

if ! printf '%s' "$slug" | grep -Eq '^[a-z0-9]+(-[a-z0-9]+)*$'; then
  echo "erro: '$slug' não é um slug válido."
  echo "      só minúsculas, dígitos e hífens. ex: quinta-do-lago"
  exit 1
fi

dest="projetos/$slug"
if [ -e "$dest" ]; then
  echo "erro: $dest já existe."
  exit 1
fi

cp -R _modelo "$dest"

# grava o slug no manifesto, para não haver divergência entre pasta e ficha
tmp="$dest/projeto.json.tmp"
sed "s/\"slug\": \"\"/\"slug\": \"$slug\"/" "$dest/projeto.json" > "$tmp"
mv "$tmp" "$dest/projeto.json"

cat <<EOF

  criado: $dest

  por colocar
  ───────────────────────────────────────────────────────────
  cards/16x9.jpg              2400×1350   miniatura desktop
  cards/3x4.jpg               1200×1600   miniatura mobile
  caso/hero.jpg               2800×1600   abertura do caso
  caso/01-vista-principal.jpg 2520×1080   21:9
  caso/02-detalhe-a.jpg       1600×1200   4:3
  caso/03-detalhe-b.jpg       1600×1200   4:3
  caso/04-interior.jpg        2520×1080   21:9

  conforme o projeto tenha
  ───────────────────────────────────────────────────────────
  filme/filme.mp4             1920×1080
  filme/poster.jpg            1600×1200   4:3
  visita/poster.jpg           1600×1200   4:3  (+ visita_url no json)
  identidade/16x9.jpg  identidade/3x4.jpg
  website/16x9.jpg     website/3x4.jpg
  suite/16x9.jpg  suite/3x4.jpg

  depois: preencher projeto.json — ficha, narrativa, resultados
          e 'direitos' (sem isso não vai a publicação).

  verificar com: ./verificar.sh

EOF
