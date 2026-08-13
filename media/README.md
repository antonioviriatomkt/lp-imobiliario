# Media — Viriato / Imobiliário

Estrutura para popular o protótipo. **Um projeto = uma pasta** em `projetos/`.
Os nomes de ficheiro são fixos — é o que permite ligar tudo ao site sem
renomear nada à mão.

## Criar um projeto novo

```bash
./novo-projeto.sh quinta-do-lago
```

Copia `_modelo/` para `projetos/quinta-do-lago/` e mostra a lista do que falta.
O `slug` (nome da pasta) é sempre minúsculas, sem acentos, com hífens.

---

## Árvore

```
media/
├── setor/hero/          vídeo de abertura da página de setor
├── projetos/            um empreendimento por pasta
│   └── <slug>/
│       ├── projeto.json ficha, narrativa, direitos
│       ├── cards/       miniaturas dos carrosséis
│       ├── caso/        página de caso de estudo
│       ├── filme/
│       ├── visita/
│       ├── identidade/
│       ├── website/
│       └── suite/
├── equipa/              4 retratos (página Sobre)
└── logos/               6 logótipos de promotores
```

---

## Nomes de ficheiro e recortes

### `setor/hero/` — abertura da página de setor

| Ficheiro | Formato | Dimensão |
|---|---|---|
| `hero.mp4` | H.264, sem áudio, 8–12 s em loop | 1920×1080 |
| `hero.webm` | VP9 (opcional, melhor compressão) | 1920×1080 |
| `hero-poster.jpg` | primeiro frame — é o que se vê antes do vídeo carregar | 1920×1080 (2560×1440 se vier de fotografia) |
| `hero-poster-3x4.jpg` | recorte vertical, usado abaixo de 1000 px | 1200×1600 |

O hero é *full-bleed* com altura entre 624 e 912 px: o recorte lateral varia
muito com a largura do ecrã. **Zona segura ao centro**, nada importante nos
20% de cada lado.

⚠️ **O 3:4 não é opcional.** Abaixo de 1000 px a caixa do hero fica quase
quadrada e o 16:9 perde metade da largura — um enquadramento que se espalhe
pelos lados (um portão à esquerda, o edifício ao fundo) desfaz-se por
completo. Tal como nos cards, é outro enquadramento, não um redimensionamento.
O vídeo não tem versão vertical: quando houver `hero.mp4`, é o 16:9 que manda
em todas as larguras.

### `<slug>/cards/` — miniaturas dos carrosséis

| Ficheiro | Rácio | Dimensão |
|---|---|---|
| `16x9.jpg` | 16:9 — desktop | 2400×1350 |
| `3x4.jpg` | 3:4 — mobile | 1200×1600 |

⚠️ **Não é um redimensionamento, é outro enquadramento.** O mesmo cartão é
16:9 no desktop e 3:4 no telemóvel. Além disso o terço inferior fica coberto
pelo véu e pela legenda — não pôr lá nada que precise de se ver.

### `<slug>/caso/` — página de caso de estudo

| Ficheiro | Rácio | Dimensão |
|---|---|---|
| `hero.jpg` | full-bleed, 440–680 px de altura | 2800×1600 |
| `01-vista-principal.jpg` | 21:9 | 2520×1080 |
| `02-detalhe-a.jpg` | 4:3 | 1600×1200 |
| `03-detalhe-b.jpg` | 4:3 | 1600×1200 |
| `04-interior.jpg` | 21:9 | 2520×1080 |

O `hero.jpg` tem o mesmo problema de zona segura do hero de setor.

### `<slug>/filme/`

| Ficheiro | Formato | Dimensão |
|---|---|---|
| `filme.mp4` | H.264 | 1920×1080 |
| `poster.jpg` | 4:3 — frame para o cartão do caso | 1600×1200 |

### `<slug>/visita/`

| Ficheiro | Notas |
|---|---|
| `visita.mp4` | H.264, 1920×1080, sem áudio — cartão em loop. **É este que garante o Safari.** |
| `visita.av1.mp4` | opcional. AV1 da mesma peça: pesa menos e é servido primeiro a quem o descodifica |
| `poster.jpg` | 4:3, 1600×1200 — frame de entrada, e o que se vê antes do vídeo carregar |
| — | o URL da visita vai em `projeto.json` → `visita_url` |

O cartão da visita aceita vídeo — e o da identidade também (ver abaixo); os
outros carrosséis são só fotografia. Se houver `visita.mp4` ou `visita.av1.mp4`,
o cartão toca em loop, sem som, e só enquanto está no ecrã; sem nenhum dos dois,
cai na foto de `cards/` como os outros carrosséis.

Pôr **só** o AV1 é um risco conhecido: o Safari só o descodifica em hardware
recente (Apple silicon M3 / A17 Pro para cima) e, num Mac ou iPhone mais antigo,
o cartão fica no poster sem nunca tocar. Para mostrar a cliente, exportar sempre
o H.264.

### `<slug>/identidade/`

Materiais gráficos: logótipo, brochura, dossier de vendas, tapumes de
estaleiro, sinalética. Uma imagem só — a melhor peça ou uma composição
das várias.

| Ficheiro | Rácio | Dimensão |
|---|---|---|
| `16x9.jpg` | 16:9 — desktop | 2400×1350 |
| `3x4.jpg` | 3:4 — mobile | 1200×1600 |
| `identidade.mp4` | opcional. H.264, sem áudio — a peça a ser folheada, em loop |
| `identidade.av1.mp4` | opcional. AV1 da mesma peça, servido primeiro a quem o descodifica |

As peças concretas listam-se em `projeto.json` → `ficha.pecas`
(ex.: "Logótipo · Brochura · Tapumes"), que é o que aparece como legenda
do cartão.

Havendo vídeo, é ele que ocupa o cartão — mesmas regras da visita: em loop,
sem som, só enquanto está no ecrã, e o H.264 é obrigatório para o Safari velho.
Vale a pena quando a peça é um objeto: uma brochura parada é uma capa, a ser
folheada é papel, formato e acabamento. O `16x9.jpg` continua a ser preciso —
serve de poster antes de o vídeo arrancar e é o que fica se o browser não tocar.
Enquadrar os dois no mesmo sítio, ou o cartão salta quando o filme começa.

Vertical (3:4, do telemóvel) não é problema: no desktop o cartão é 16:9 e corta
a faixa central, por isso o que tem de se ler — o wordmark — tem de estar a
meia altura do frame. No telemóvel encaixa inteiro.

O `Brochura Farimovel_V2.mp4` do Natura Village é o exemplo montado: original de
9,7 Mbps com áudio à parte, servido a 2,8 Mbps sem áudio (3,5 MB para 10s).

### `<slug>/website/`

Screenshot ou mockup do site do empreendimento. Enquadrar o topo da
página — é o que se reconhece.

| Ficheiro | Rácio | Dimensão |
|---|---|---|
| `16x9.jpg` | 16:9 — desktop | 2400×1350 |
| `3x4.jpg` | 3:4 — mobile | 1200×1600 |

O domínio vai em `projeto.json` → `ficha.dominio` (legenda do cartão) e o
endereço completo em `site_url`.

### `<slug>/suite/`

| Ficheiro | Notas |
|---|---|
| `16x9.jpg` | 2400×1350 — mockup de marca/site/landing/materiais |
| `3x4.jpg` | 1200×1600 |

Só é preciso se o projeto aparecer no carrossel Marketing Suite.

### `equipa/` — 4 retratos

`01-<nome>.jpg` … `04-<nome>.jpg` — 3:4, 1200×1600.
Mesma luz e mesmo fundo nos quatro, senão a grelha desfaz-se.

### `logos/` — 6 promotores

`01-<promotor>.svg` … `06-<promotor>.svg`.
SVG de preferência. Se não houver, PNG com fundo transparente, 600 px de
largura. Sobre papel, logótipos em branco desaparecem — pedir a versão
monocromática escura.

---

## Quanto é preciso

| | Projetos | Peças |
|---|---|---|
| Mínimo | 5 | ~69 |
| Confortável | 8 | ~90 |
| Ideal | 12 | ~118 |

Restrição real, por carrossel: **4** projetos com identidade, **5** com
imagens, **4** com filme, **4** com visita 360º, **4** com website, **4**
com Marketing Suite,
e os **3** melhores em "Empreendimentos que ajudámos a vender". Um projeto pode aparecer em vários
carrosséis — mas só se tiver mesmo esse material.

---

## Regras que evitam retrabalho

1. **Sem acentos nem espaços** em nomes de pastas ou ficheiros.
2. **JPEG a 80%** para fotografia; PNG só para logótipos e mockups com texto.
3. **Nada de imagens com mais de 3000 px** de largura — não acrescentam nada
   e pesam na abertura da página.
4. **`direitos` preenchido em `projeto.json`** antes de publicar: fotógrafo,
   licença e aprovação do cliente. Um projeto sem isto não vai ao site.
5. **Um projeto incompleto não entra num carrossel.** Vale mais 5 projetos
   inteiros do que 10 pela metade.
