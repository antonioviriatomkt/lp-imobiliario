#!/usr/bin/env bash
# Gera os recortes que o site consome (cards/ e caso/) a partir dos originais
# que estão dentro de cada pasta de projeto.
#
# O mapa em baixo é a única coisa a editar: diz que original alimenta que slot,
# e onde é que o recorte deve ficar ancorado (ax/ay, 0=esquerda/topo,
# 1=direita/fundo — por omissão 0.5, ou seja, ao centro).
#
#     ./gerar-recortes.sh          e a seguir ./gerar-dados.sh
set -euo pipefail
cd "$(dirname "$0")"

python3 - <<'PY'
# -*- coding: utf-8 -*-
import io, os
from PIL import Image

# slot -> (largura, altura) — os tamanhos do README
SLOTS = {
    'cards/16x9.jpg':            (2400, 1350),
    'cards/3x4.jpg':             (1200, 1600),
    'caso/hero.jpg':             (2800, 1600),
    'caso/01-vista-principal.jpg': (2520, 1080),
    'caso/02-detalhe-a.jpg':     (1600, 1200),
    'caso/03-detalhe-b.jpg':     (1600, 1200),
    'caso/04-interior.jpg':      (2520, 1080),
    'identidade/16x9.jpg':       (2400, 1350),
    'identidade/3x4.jpg':        (1200, 1600),
    'visita/poster.jpg':         (1600, 1200),
}

# projeto -> slot -> original [, ax, ay]
MAPA = {
 'va-atlantic-pearl-esposende': {
   'cards/16x9.jpg':              ('exterior/exterior-2.jpg', .5, .45),
   'cards/3x4.jpg':               ('exterior/exterior-2.jpg', .5, .5),
   'caso/hero.jpg':               ('exterior/exterior-1.jpg', .5, .45),
   'caso/01-vista-principal.jpg': ('exterior/exterior-3.jpg', .5, .55),
   'caso/02-detalhe-a.jpg':       ('interior/sala-1.jpg',),
   'caso/03-detalhe-b.jpg':       ('interior/cozinha-1.jpg', .5, .45),
   'caso/04-interior.jpg':        ('interior/rooftop-1.jpg', .5, .55),
 },
 # O poster da visita sai do primeiro frame do próprio vídeo (visita-frame.jpg),
 # não de um render: é o frame em que a visita começa, e assim o cartão não
 # salta de uma imagem para outra quando o filme arranca.
 'va-villa-heaven-vale-do-lobo': {
   'visita/poster.jpg':           ('visita/visita-frame.jpg', .5, .5),
   'cards/16x9.jpg':              ('exterior/Villa-Heaven_Exterior_Cam_2.jpg', .5, .55),
   'cards/3x4.jpg':               ('exterior/Villa-Heaven_Exterior_Cam_2.jpg', .55, .5),
   'caso/hero.jpg':               ('exterior/Villa-heaven-Imagem-aerea_.jpg', .5, .5),
   'caso/01-vista-principal.jpg': ('exterior/Villa-Heaven_Exterior_Cam_6.jpg', .5, .55),
   'caso/02-detalhe-a.jpg':       ('interior/VA_Properties_Villa-Heaven_LOTE_05_Camera_Sala_001.jpg',),
   'caso/03-detalhe-b.jpg':       ('interior/VA_Properties_Villa-Heaven_LOTE_05_Camera_Porm_Cozinha_001.jpg',),
   'caso/04-interior.jpg':        ('interior/VA_Properties_Villa-Heaven_LOTE_05_Camera_Porm_Piscina_01.jpg',),
 },
 'vanguard-comporta': {
   'cards/16x9.jpg':              ('Exterior/Exterior_Cam04_Fachada_Piscina_Lateral.jpg', .5, .55),
   'cards/3x4.jpg':               ('Exterior/Vanguard_Comporta_Cam05_Terraco.jpg', .5, .5),
   'caso/hero.jpg':               ('Exterior/Exterior_Cam03_Terraco_Zona_Refeicao_Piscina.jpg', .5, .5),
   'caso/01-vista-principal.jpg': ('Exterior/Exterior_Cam02_Fachada_Piscina_Frontal.jpg', .5, .5),
   'caso/02-detalhe-a.jpg':       ('Interior/Vanguard_Camera - Cozinha_V1.jpg',),
   'caso/03-detalhe-b.jpg':       ('Interior/Vanguard_Camera - Master Suite.jpg',),
   'caso/04-interior.jpg':        ('Interior/Vanguard_Camera - Sala Exterior_V1.jpg',),
 },
 # A identidade deste projeto é vídeo — a brochura a ser folheada, em
 # identidade/identidade.mp4. Estes dois recortes são a rede por baixo dele: o
 # poster que se vê antes de arrancar e a foto que fica se o browser não tocar.
 # Saem do frame da capa (brochura-capa.jpg), que é onde o wordmark se lê.
 #
 # O original é 3:4, por isso o 3x4 não corta nada. No 16:9 sobram 608px de
 # altura de 1440 e a marca não cabe inteira: ao centro fica «NATURA VILLAGE /
 # SIGNATURE HOMES / CRISTELO», que é o que tem de se ler — a folha em cima e o
 # «A BYLIVING PROJECT» em baixo ficam fora. É o mesmo enquadramento que o
 # object-fit:cover dá ao vídeo no cartão de desktop, logo o poster não salta
 # quando o filme arranca.
 'natura-village': {
   'cards/16x9.jpg':              ('By-Living-Exterior-2.webp', .5, .5),
   'cards/3x4.jpg':               ('By-Living-Exterior-1.webp', .5, .45),
   'identidade/16x9.jpg':         ('brochura-capa.jpg', .5, .5),
   'identidade/3x4.jpg':          ('brochura-capa.jpg', .5, .5),
   'caso/hero.jpg':               ('By-Living-Exterior-3.webp', .5, .55),
   'caso/01-vista-principal.jpg': ('By-Living-Sala-Estar-1.webp', .5, .5),
   'caso/02-detalhe-a.jpg':       ('By-Living-Cozinha.webp', .5, .45),
   'caso/03-detalhe-b.jpg':       ('By-Living-Piso02-Master-Suite.webp',),
   'caso/04-interior.jpg':        ('By-Living-Piso02-Suite-01.webp',),
 },
 'up-pure-santa-joana': {
   'cards/16x9.jpg':              ('Evergreen_SantaJoana_T2_EXT_EdificioCamera 03-1.webp', .5, .45),
   'cards/3x4.jpg':               ('Evergreen_SantaJoana_Bloco 01_T2_Cam_Exterior_002_V1-1.webp', .5, .45),
   'caso/hero.jpg':               ('Evergreen_SantaJoana_T2_EXT_EdificioCamera 03-1.webp', .5, .5),
   'caso/01-vista-principal.jpg': ('Evergreen_SantaJoana_Bloco 01_T2_Cam_Exterior_002_V1-1.webp', .5, .5),
   'caso/02-detalhe-a.jpg':       ('Evergreen_SantaJoana_T1_Cam_Sala_Horiz_001_V1-1.webp',),
   'caso/03-detalhe-b.jpg':       ('Evergreen_SantaJoana_Bloco 01_T2_Cam_Quarto_001_V1-1.webp',),
   'caso/04-interior.jpg':        ('Evergreen_SantaJoana_Bloco 01_T2_Cam_Sala_001_V1-1.webp',),
 },
 # O original é 9:16 e tem duas peças empilhadas: a capa fechada com o wordmark
 # (y 340-900) e o miolo aberto (y 910-1600), sobre travertino.
 #
 # No 16:9 do desktop só cabem 608px de altura — não dá para as duas. Fica a
 # capa: num cartão de identidade é o wordmark que tem de se ler, não uma
 # dupla. .24 centra a janela nela; ao centro do original apanhava metade de
 # cada peça e a lombada pelo meio.
 #
 # O 3:4 é alto que chegue para as duas, e é melhor assim — mostra que há
 # brochura e não só capa. .18 corta a pedra vazia do topo.
 'serralves-garden-porto': {
   'identidade/16x9.jpg':         ('Viriato_brochura-Serralves-Garden.png', .5, .24),
   'identidade/3x4.jpg':          ('Viriato_brochura-Serralves-Garden.png', .5, .18),
 },
 'up-village-fermentelos': {
   'cards/16x9.jpg':              ('dawd.jpeg', .5, .5),
   'cards/3x4.jpg':               ('LOUREIRO FIRM_Evergreen Village_brochura v8.jpeg', .5, .4),
   'caso/hero.jpg':               ('ada.jpeg', .5, .5),
   'caso/01-vista-principal.jpg': ('rwrr.jpeg', .5, .5),
   'caso/02-detalhe-a.jpg':       ('rwrsrf.jpeg', .5, .5),
   'caso/03-detalhe-b.jpg':       ('jjjjj.jpeg', .5, .5),
   'caso/04-interior.jpg':        ('rrserf.jpeg', .5, .5),
 },
}

def recorte(src, dst, w, h, ax=.5, ay=.5):
    im = Image.open(src)
    im = im.convert('RGB')
    alvo, atual = w / float(h), im.width / float(im.height)
    if atual > alvo:                      # original mais largo: corta nos lados
        nw, nh = int(round(im.height * alvo)), im.height
    else:                                 # original mais alto: corta em cima/baixo
        nw, nh = im.width, int(round(im.width / alvo))
    x = int(round((im.width - nw) * ax))
    y = int(round((im.height - nh) * ay))
    im = im.crop((x, y, x + nw, y + nh))
    if im.width != w:
        im = im.resize((w, h), Image.LANCZOS)
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    im.save(dst, 'JPEG', quality=80, optimize=True, progressive=True)
    return im

# hero da página de setor. Agora abre em vídeo (setor/hero/hero.mp4), por isso
# o poster deixou de ser uma fotografia escolhida à parte e passa a ser o
# primeiro frame do reel, guardado em hero-frame.jpg — é o que evita o salto
# entre o que se vê a carregar e o que se vê a tocar.
#
# O 16:9 fica em 1920×1080, o tamanho nativo do frame: esticá-lo para os
# 2560×1440 de uma fotografia só pesava mais para ver o mesmo.
#
# Dois recortes, não um redimensionamento: abaixo de 1000px a caixa do hero
# fica quase quadrada e o 16:9 perde os lados. Com vídeo é o 16:9 que manda em
# todas as larguras — o 3:4 fica de reserva, para o dia em que se tirar o reel.
HERO = [
  ('setor/hero/hero-frame.jpg',
   'setor/hero/hero-poster.jpg',     1920, 1080, .5, .5),
  ('setor/hero/hero-frame.jpg',
   'setor/hero/hero-poster-3x4.jpg', 1200, 1600, .5, .5),
]

for slug in sorted(MAPA):
    base = os.path.join('projetos', slug)
    for slot, spec in MAPA[slug].items():
        src = os.path.join(base, spec[0])
        if not os.path.isfile(src):
            print('  FALTA %s  (%s)' % (src, slot)); continue
        w, h = SLOTS[slot]
        recorte(src, os.path.join(base, slot), w, h, *spec[1:])
    print('  %-30s %d recortes' % (slug, len(MAPA[slug])))

for src, dst, w, h, ax, ay in HERO:
    if os.path.isfile(src):
        recorte(src, dst, w, h, ax, ay)
        print('  %-30s %s' % ('setor/hero', dst))
    else:
        print('  FALTA %s  (hero de setor)' % src)
PY
