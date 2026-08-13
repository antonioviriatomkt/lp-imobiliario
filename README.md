# lp-imobiliario

Página de **imobiliário** da Viriato — comprador-alvo: o **promotor**. PT-PT.
Ficheiro único, sem build: `index.html` + `dados.js` + `media/`.

Ao ar: <https://viriato-prototipo-imobiliario.vercel.app> (projeto Vercel
`viriato-prototipo-imobiliario`, `noindex` por omissão).

## ⚠️ O que está aqui hoje

O que está neste repositório é o **protótipo da página de setor permanente**
(`/setores/imobiliario`, v0.2, *work-first*) — nav completa, três vistas
(setor · caso de estudo · sobre), barra de salto, tiers, motor de procura.

**Não é** a landing page da campanha paga de agosto. Essa é outra página, com
outras regras: fora do menu, navegação reduzida, um só caminho, CTA de WhatsApp
+ chamada de diagnóstico, sem tiers, sem motor de procura, em PT-PT e EN.
As duas não se fundem — canibalizam-se em SEO.

Contexto e decisões no vault: `WORK/Clients/Viriato/` →
`decisions/2026-07-28-estrutura-pagina-imobiliario.md`,
`paid-advertising/imobiliario-pt-de-campaign.md` e
`tasks/propor-landing-pages-campanhas.md`.

## Estrutura

| Ficheiro | O que é |
|---|---|
| `index.html` | A página inteira — markup, estilos e comportamento |
| `dados.js` | Conteúdo: `SETOR` (a página) + `PROJETOS` (os empreendimentos) |
| `SPEC.md` | Especificação para o developer: arquitetura, tokens, SEO, conteúdo em falta |
| `tokens-papel.html` | Referência visual do sistema de tokens |
| `publicar.sh` | Monta a pasta de deploy a partir do `dados.js` e publica na Vercel |
| `media/*.sh` | Geradores: novo projeto, recortes canónicos, entradas do `dados.js` |

## Publicar

```bash
./publicar.sh          # pré-visualização, URL descartável
./publicar.sh --prod   # produção
```

O script não sobe a pasta: lê o `dados.js`, copia **só os ficheiros que ele
referencia** para uma pasta temporária e publica essa. O que não estiver
referenciado fica em terra por omissão.

## O que não está no repositório

A pasta `media/` em disco pesa ~530 MB; aqui estão ~45 MB. A diferença são os
**originais que alimentam os geradores** — renders a 20 MB, masters de brochura,
o reel do hero em 30 MB. São entrada, não saída, e vivem no Dropbox:

```
~/Library/CloudStorage/Dropbox/WORK/Clients/Viriato/prototypes/imobiliario/
```

O que está versionado são os **derivados servidos** (`cards/`, `caso/`,
`identidade/`, `visita/`, `setor/hero/`) mais os `*-frame.jpg`, que chegam para
refazer os posters sem ter os masters à mão. Um clone limpo serve a página e
publica; só não regenera recortes a partir dos originais. Ver `.gitignore`.
