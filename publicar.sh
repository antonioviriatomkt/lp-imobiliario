#!/usr/bin/env bash
# Monta a pasta que vai para o ar e publica-a na Vercel.
#
# A pasta do protótipo tem ~495 MB, mas o site só serve ~73 MB: o resto são os
# originais que alimentam os geradores (renders a 20 MB, masters de brochura,
# o reel do hero em 31 MB). Nada disso tem de subir. Em vez de uma lista de
# exclusões a apodrecer, isto faz o contrário: lê o dados.js, sobe só o que ele
# referencia mesmo, e o que não estiver referenciado fica em terra por omissão.
#
#     ./publicar.sh            # deploy de pré-visualização, URL descartável
#     ./publicar.sh --prod     # produção
set -euo pipefail
cd "$(dirname "$0")"

PROJETO="viriato-prototipo-imobiliario"
SAIDA="${TMPDIR:-/tmp}/$PROJETO"

# Ficheiros referenciados pelo dados.js que, ainda assim, não sobem. A entrada
# correspondente é posta a null na cópia do dados.js — sem isso o browser pedia
# um ficheiro que não está lá e ficava com um 404 na consola em vez de cair na
# fotografia como deve ser.
#
# visita.av1.mp4: 43 MB para os mesmos 42 s que o visita.mp4 faz em 13 MB. O
# AV1 devia pesar menos que o H.264 e aqui pesa o triplo — a exportação saiu
# mal. Como o browser escolhe a primeira fonte que sabe descodificar, deixá-lo
# subir era servir 43 MB a quem tem Chrome e 13 MB ao resto. Fica em terra até
# haver uma exportação que justifique o formato.
EXCLUIR=( "media/projetos/va-villa-heaven-vale-do-lobo/visita/visita.av1.mp4" )

rm -rf "$SAIDA"; mkdir -p "$SAIDA"
cp index.html "$SAIDA/"

EXCLUIR_STR="$(printf '%s\n' "${EXCLUIR[@]}")" python3 - "$SAIDA" <<'PY'
# -*- coding: utf-8 -*-
import io, json, os, re, shutil, sys

saida = sys.argv[1]
excluir = set(filter(None, os.environ['EXCLUIR_STR'].split('\n')))

fonte = io.open('dados.js', encoding='utf-8').read()
cab, corpo = fonte.split('const SETOR = ', 1)
setor_txt, projetos_txt = corpo.split('const PROJETOS = ', 1)
setor = json.loads(setor_txt.rstrip().rstrip(';'))
projetos = json.loads(projetos_txt.rstrip().rstrip(';'))

def limpar(v):
    """Põe a null tudo o que está na lista de exclusão, para o dados.js que
       sobe dizer a verdade sobre o que existe do outro lado."""
    if isinstance(v, dict):
        return dict((k, limpar(x)) for k, x in v.items())
    if isinstance(v, list):
        return [limpar(x) for x in v]
    return None if v in excluir else v

setor = limpar(setor)
projetos = limpar(projetos)

out = io.open(os.path.join(saida, 'dados.js'), 'w', encoding='utf-8')
out.write(cab)
out.write('const SETOR = %s;\n\n' % json.dumps(setor, ensure_ascii=False, indent=2))
out.write('const PROJETOS = %s;\n' % json.dumps(projetos, ensure_ascii=False, indent=2))
out.close()

# copiar só os media que sobraram referenciados
copiados = total = 0
faltam = []
for caminho in sorted(set(re.findall(r'"(media/[^"]+)"',
                     io.open(os.path.join(saida, 'dados.js'), encoding='utf-8').read()))):
    if not os.path.isfile(caminho):
        faltam.append(caminho); continue
    destino = os.path.join(saida, caminho)
    os.makedirs(os.path.dirname(destino), exist_ok=True)
    shutil.copy2(caminho, destino)
    copiados += 1; total += os.path.getsize(caminho)

print('  %d ficheiro(s) · %.1f MB' % (copiados, total / 1048576.0))
for f in faltam:
    print('  FALTA %s' % f)
for f in sorted(excluir):
    print('  de fora %s' % f)
PY

# Protótipo de cliente: fora dos motores de busca. O media leva cache longa —
# os nomes são estáveis, mas cada deploy serve ficheiros novos na mesma.
cat > "$SAIDA/vercel.json" <<'JSON'
{
  "$schema": "https://openapi.vercel.sh/vercel.json",
  "headers": [
    { "source": "/(.*)",
      "headers": [{ "key": "X-Robots-Tag", "value": "noindex, nofollow" }] },
    { "source": "/media/(.*)",
      "headers": [{ "key": "Cache-Control", "value": "public, max-age=31536000, immutable" }] }
  ]
}
JSON

echo "  montado em $SAIDA"
cd "$SAIDA"
if [ "${1:-}" = "--prod" ]; then
  vercel deploy --prod --yes
else
  vercel deploy --yes
fi
