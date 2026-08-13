# lp-imobiliario

Página de **imobiliário** da Viriato — comprador-alvo: o **promotor**. PT-PT.
Ficheiro único, sem build: `index.html` + `dados.js` + `media/`.

Ao ar: <https://viriato-prototipo-imobiliario.vercel.app> (projeto Vercel
`viriato-prototipo-imobiliario`, `noindex` por omissão).

## ⚠️ Duas páginas, e não se fundem

| | `index.html` | `lp-en.html` |
|---|---|---|
| O que é | Protótipo da **página de setor permanente** (`/setores/imobiliario`, v0.2) | **Landing da campanha paga**, Alemanha, inglês |
| Tráfego | Orgânico e referência | Só pago — Google Search DE + Meta DE |
| Navegação | Completa, três vistas, barra de salto | Nenhuma. Um só caminho |
| CTA | Formulário de diagnóstico | WhatsApp (primário) + chamada de diagnóstico |
| Tiers | Três perfis de promotor | Não tem — demasiado para uma LP |
| Índice | Indexável | `noindex, nofollow` |

Atacam os mesmos termos: se as duas ficarem indexadas, canibalizam-se. Daí o
`noindex` na LP, reforçado pelo cabeçalho que o `publicar.sh` escreve.

A instância **PT-PT ainda não existe** e é a próxima coisa a fazer — sem ela o
Meta·Portugal, que é ~40% do orçamento do imobiliário, não tem onde aterrar.

Contexto e decisões no vault: `WORK/Clients/Viriato/` →
`decisions/2026-07-28-estrutura-pagina-imobiliario.md`,
`decisions/2026-08-13-estrutura-lp-imobiliario-campanha.md`,
`paid-advertising/imobiliario-pt-de-campaign.md` e
`tasks/propor-landing-pages-campanhas.md`.

## Estrutura

| Ficheiro | O que é |
|---|---|
| `index.html` | Página de setor — markup, estilos e comportamento |
| `lp-en.html` | Landing de campanha EN — idem, e partilha o `dados.js` |
| `dados.js` | Conteúdo: `SETOR` (o hero) + `PROJETOS` (os empreendimentos) |
| `SPEC.md` | Especificação da página de setor. ⚠️ §7 descreve o tema escuro de 2027; a página está em «papel» desde 11/08 e a spec ainda não foi atualizada |
| `tokens-papel.html` | Referência visual do sistema de tokens em uso |
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
