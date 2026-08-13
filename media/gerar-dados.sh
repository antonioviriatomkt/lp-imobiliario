#!/usr/bin/env bash
# Lê projetos/*/projeto.json + os ficheiros que existem mesmo em disco
# e escreve ../dados.js, que o index.html carrega.
#
# Correr sempre que se acrescenta media ou se edita um projeto.json:
#     ./gerar-dados.sh
set -euo pipefail
cd "$(dirname "$0")"

python3 - <<'PY'
# -*- coding: utf-8 -*-
import io, json, os, glob

def existe(p):
    return p if os.path.isfile(p) else None

def rel(p):
    # caminhos relativos ao index.html, que está um nível acima de media/
    return 'media/' + p if p else None

projetos = []
for j in sorted(glob.glob('projetos/*/projeto.json')):
    d = os.path.dirname(j)
    slug = os.path.basename(d)
    try:
        p = json.load(io.open(j, encoding='utf-8'))
    except ValueError as e:
        print('  ERRO de sintaxe em %s: %s' % (j, e))
        raise SystemExit(1)

    p['slug'] = p.get('slug') or slug
    p.pop('_comentario_carrosseis', None)
    p.pop('_comentario_direitos', None)

    p['media'] = {
        'card16':  rel(existe(d + '/cards/16x9.jpg')),
        'card34':  rel(existe(d + '/cards/3x4.jpg')),
        'ident16': rel(existe(d + '/identidade/16x9.jpg')),
        'ident34': rel(existe(d + '/identidade/3x4.jpg')),
        # identidade: quando a peça é uma brochura, um dossier ou um tapume, o
        # que se está a mostrar é um objeto — e vê-se melhor a ser folheado do
        # que parado. Mesmo contrato da visita: se houver vídeo o cartão toca em
        # loop, sem som, só à vista; sem ele fica o 16x9.jpg, que também serve de
        # poster. O AV1 é opcional e vai primeiro a quem o descodifica.
        'identAv1': rel(existe(d + '/identidade/identidade.av1.mp4')),
        'identMp4': rel(existe(d + '/identidade/identidade.mp4')),
        'web16':   rel(existe(d + '/website/16x9.jpg')),
        'web34':   rel(existe(d + '/website/3x4.jpg')),
        'suite16': rel(existe(d + '/suite/16x9.jpg')),
        'suite34': rel(existe(d + '/suite/3x4.jpg')),
        'hero':    rel(existe(d + '/caso/hero.jpg')),
        'caso': [
            rel(existe(d + '/caso/01-vista-principal.jpg')),
            rel(existe(d + '/caso/02-detalhe-a.jpg')),
            rel(existe(d + '/caso/03-detalhe-b.jpg')),
            rel(existe(d + '/caso/04-interior.jpg')),
            rel(existe(d + '/filme/poster.jpg')),
            rel(existe(d + '/visita/poster.jpg')),
        ],
        'filme':   rel(existe(d + '/filme/filme.mp4')),
        # visita: o cartão do carrossel pode ser vídeo em loop em vez de foto.
        # Duas codificações, porque nenhuma sozinha chega a toda a gente: o AV1
        # pesa menos mas o Safari só o descodifica em hardware recente, e o H.264
        # toca em todo o lado. O index.html oferece as duas ao browser por esta
        # ordem e ele escolhe. Sem nenhuma delas, o cartão volta à foto.
        'visitaAv1':    rel(existe(d + '/visita/visita.av1.mp4')),
        'visitaMp4':    rel(existe(d + '/visita/visita.mp4')),
        'visitaPoster': rel(existe(d + '/visita/poster.jpg')),
    }
    projetos.append(p)

# Ordem dos cartões em todos os carrosséis. Por omissão é alfabética por slug —
# que é ordem de arquivo, não ordem editorial. Pôr "ordem": 1 num projeto.json
# puxa esse projeto para a frente; quem não tem fica atrás, na mesma ordem de
# sempre. Ordenação estável, logo os empates não baralham nada.
projetos.sort(key=lambda p: p.get('ordem') if isinstance(p.get('ordem'), int) else 10**6)

setor = {
    'heroVideo':  rel(existe('setor/hero/hero.mp4')),
    'heroWebm':   rel(existe('setor/hero/hero.webm')),
    'heroPoster': rel(existe('setor/hero/hero-poster.jpg')),
    'heroPoster34': rel(existe('setor/hero/hero-poster-3x4.jpg')),
    'equipa':     [rel(f) for f in sorted(glob.glob('equipa/*.jpg'))],
    'logos':      [rel(f) for f in sorted(glob.glob('logos/*.svg')) +
                            sorted(glob.glob('logos/*.png'))],
}

out = io.open('../dados.js', 'w', encoding='utf-8')
out.write('/* GERADO POR media/gerar-dados.sh — não editar à mão.\n'
          '   Editar media/projetos/<slug>/projeto.json e voltar a correr. */\n')
out.write('const SETOR = %s;\n\n' % json.dumps(setor, ensure_ascii=False, indent=2))
out.write('const PROJETOS = %s;\n' % json.dumps(projetos, ensure_ascii=False, indent=2))
out.close()

n = len(projetos)
carros = {}
for k in ('casos', 'identidade', 'imagens', 'filmes', 'visitas', 'website', 'suite'):
    carros[k] = sum(1 for p in projetos if p.get('aparece_em', {}).get(k))
print('  dados.js escrito — %d projeto(s)' % n)
if n:
    print('  carrosséis: ' + '  '.join('%s %d' % (k, v) for k, v in carros.items()))
else:
    print('  (sem projetos: o protótipo fica com os placeholders)')
PY
