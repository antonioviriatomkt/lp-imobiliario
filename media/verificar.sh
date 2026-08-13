#!/usr/bin/env bash
# Mostra o que falta para o site poder ser ligado aos ficheiros.
# uso: ./verificar.sh
set -uo pipefail
cd "$(dirname "$0")"

ok=0; falta=0
say(){ printf '%s\n' "$1"; }
chk(){ # chk <ficheiro> <etiqueta>
  if [ -f "$1" ]; then ok=$((ok+1));
  else falta=$((falta+1)); say "      falta  $2"; fi
}

say ""
say "  SETOR"
say "  ─────────────────────────────────────────────"
chk "setor/hero/hero.mp4"        "setor/hero/hero.mp4"
chk "setor/hero/hero-poster.jpg" "setor/hero/hero-poster.jpg"
chk "setor/hero/hero-poster-3x4.jpg" "setor/hero/hero-poster-3x4.jpg"

say ""
say "  PROJETOS"
say "  ─────────────────────────────────────────────"
n=0
declare -i c_casos=0 c_identidade=0 c_imagens=0 c_filmes=0 c_visitas=0 c_website=0 c_suite=0
for d in projetos/*/; do
  [ -d "$d" ] || continue
  n=$((n+1))
  slug="$(basename "$d")"
  say "    $slug"
  chk "${d}cards/16x9.jpg"              "${slug} · cards/16x9.jpg"
  chk "${d}cards/3x4.jpg"               "${slug} · cards/3x4.jpg"
  chk "${d}caso/hero.jpg"               "${slug} · caso/hero.jpg"
  chk "${d}caso/01-vista-principal.jpg" "${slug} · caso/01-vista-principal.jpg"
  chk "${d}caso/02-detalhe-a.jpg"       "${slug} · caso/02-detalhe-a.jpg"
  chk "${d}caso/03-detalhe-b.jpg"       "${slug} · caso/03-detalhe-b.jpg"
  chk "${d}caso/04-interior.jpg"        "${slug} · caso/04-interior.jpg"

  j="${d}projeto.json"
  if [ -f "$j" ]; then
    grep -q '"aprovado_pelo_cliente": true' "$j" || say "      aviso  ${slug} · direitos por aprovar"
    for k in casos identidade imagens filmes visitas website suite; do
      if grep -A10 '"aparece_em"' "$j" | grep -q "\"$k\": true"; then
        case "$k" in
          casos)   c_casos+=1 ;;
          identidade) c_identidade+=1; chk "${d}identidade/16x9.jpg" "${slug} · identidade/16x9.jpg"
                                       chk "${d}identidade/3x4.jpg"  "${slug} · identidade/3x4.jpg" ;;
          imagens) c_imagens+=1 ;;
          filmes)  c_filmes+=1;  chk "${d}filme/filme.mp4"   "${slug} · filme/filme.mp4"
                                 chk "${d}filme/poster.jpg"  "${slug} · filme/poster.jpg" ;;
          visitas) c_visitas+=1; chk "${d}visita/poster.jpg" "${slug} · visita/poster.jpg" ;;
          website) c_website+=1; chk "${d}website/16x9.jpg"  "${slug} · website/16x9.jpg"
                                 chk "${d}website/3x4.jpg"   "${slug} · website/3x4.jpg" ;;
          suite)   c_suite+=1;   chk "${d}suite/16x9.jpg"    "${slug} · suite/16x9.jpg"
                                 chk "${d}suite/3x4.jpg"     "${slug} · suite/3x4.jpg" ;;
        esac
      fi
    done
  else
    falta=$((falta+1)); say "      falta  ${slug} · projeto.json"
  fi
done
[ "$n" -eq 0 ] && say "    (nenhum — correr ./novo-projeto.sh <slug>)"

say ""
say "  EQUIPA E LOGÓTIPOS"
say "  ─────────────────────────────────────────────"
e=$(ls equipa/*.jpg 2>/dev/null | wc -l | tr -d ' ')
l=$(ls logos/*.svg logos/*.png 2>/dev/null | wc -l | tr -d ' ')
say "    equipa   $e/4"
say "    logos    $l/6"

say ""
say "  COBERTURA DOS CARROSSÉIS  (necessário para encher o layout)"
say "  ─────────────────────────────────────────────"
cov(){ # cov <atual> <preciso> <nome>
  if [ "$1" -ge "$2" ]; then printf '    ok    %-10s %s/%s\n' "$3" "$1" "$2"
  else printf '    curto %-10s %s/%s\n' "$3" "$1" "$2"; fi
}
cov "$c_casos"      3 "casos"
cov "$c_identidade" 4 "identidade"
cov "$c_imagens"    5 "imagens"
cov "$c_filmes"     4 "filmes"
cov "$c_visitas"    4 "visitas"
cov "$c_website"    4 "website"
cov "$c_suite"      4 "suite"

say ""
say "  ─────────────────────────────────────────────"
say "    $n projeto(s) · $ok ficheiro(s) no sítio · $falta em falta"
say ""
