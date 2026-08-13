# Viriato · `/setores/imobiliario` — Especificação para desenvolvimento

**Versão:** 0.2 (protótipo, work-first) · **Data:** 2026-07-28 · **Responsável:** António
**Protótipo clicável:** `index.html` — abrir no browser; a barra inferior comuta entre as três vistas.

> **v0.2 substitui a v0.1.** A primeira versão era orientada a copy e argumentação — parecia uma landing page B2B genérica. Esta é orientada ao trabalho, como a Mino e a The Boundary: **a obra é o argumento**. A copy foi reduzida a legendas e a página passou a funcionar como ferramenta de vendas.

---

## 0. Duas funções, uma página

| Função | Quem usa | O que exige |
|---|---|---|
| **Página de setor pública** | Promotor que chega por pesquisa ou referência | SEO, conteúdo autorizado, formulário |
| **Ferramenta de vendas** | Comercial, ao vivo, à frente de um promotor | Acesso rápido a qualquer caso, pouca copy, visual grande, nada embaraçoso ao fazer scroll |

A segunda função é a que mais condiciona o desenho. Decisão: **a própria página é a ferramenta** — não há modo de apresentação separado. Consequências obrigatórias:

- **Barra de salto pegajosa** (`.jump`) por baixo do header, sempre visível: Casos · Imagens · Filmes · Visitas · Suite · Motor · Soluções · Contacto. O comercial salta direto para o que interessa àquele cliente, sem fazer scroll por argumentação.
- **Casos de estudo em terceiro lugar na página**, logo a seguir ao hero e à barra de salto. São prioridade, não conclusão.
- **Pouca copy.** Nenhum bloco de texto com mais de duas linhas acima da secção Soluções. O comercial fala; a página mostra.
- **Carrosséis horizontais** (`.rail`) em cada componente — arrastar com o rato ou o dedo, funciona bem em portátil e em tablet numa reunião.
- Sem *pop-ups*, sem *cookie banner* a tapar o ecrã no meio de uma demonstração (o consentimento tem de ser discreto e memorizado).

**Nota:** todo o conteúdo é público — não há pool separado de material sob NDA. Se surgir trabalho confidencial que o comercial queira mostrar, é uma decisão nova e implica uma área reservada.

---

## 1. Arquitetura

```
/setores/imobiliario          ← página principal (view 1)
/casos-de-estudo/{slug}       ← template de caso (view 2)
/sobre                        ← institucional (view 3)
```

Casos vivem num **namespace plano** `/casos-de-estudo/{slug}` e são apresentados por vistas (por setor, por componente). Um mesmo empreendimento aparece em vários componentes — é assim que a Boundary faz 87 casos parecerem infinitos, e é o oposto do erro da Mino, que duplica cada projeto em `/services/images-gallery/` e `/services/brand-identity/`.

> ⚠️ Esta é a **página de setor permanente**, não uma landing de campanha. A landing de abril é outra página, fora do menu, com nav reduzida e um só CTA. Tráfego pago nunca aterra aqui.

---

## 2. Sequência de secções

| # | Secção | Função | Componente |
|---|---|---|---|
| 1 | Hero | Uma frase sobre imagem full-bleed | `.hero` |
| 2 | Barra de salto | Navegação da ferramenta de vendas | `.jump` |
| 3 | **Casos em destaque** | Prova, logo no topo | `.feat` + `.fcase` ×3 |
| 4 | 01 Imagens | Showcase | `.comp` + `.rail` |
| 5 | 02 Filmes | Showcase | `.comp` + `.rail` |
| 6 | 03 Visitas virtuais | Showcase | `.comp` + `.rail` |
| 7 | 04 Marketing Suite | Showcase | `.comp` + `.rail` |
| 8 | 05 Motor de procura | Diferenciador + barreira | `.comp.tech` + `.motorbox` |
| 9 | Percurso do lançamento | Contexto, 5 fases compactas | `.phases` |
| 10 | Soluções (tiers) | Autoqualificação | `.tier` ×3 |
| 11 | Com quem trabalhamos | Filtro de leads | `.qcol` ×2 |
| 12 | Prova | Logótipos + testemunho | `.logos` + `.quote` |
| 13 | FAQ | Objeções + AEO | `<details>` |
| 14 | Contacto | Conversão qualificada | `form` |

**Lógica:** as secções 1–8 são visuais e ocupam a maior parte da página. As 9–14 são o fecho comercial e vivem abaixo. Um promotor que só faz scroll pelo topo vê obra; um que desce até ao fim encontra preço, qualificação e formulário.

---

## 3. A espinha — componentes, não serviços

Cada showcase é: `número` + `nome` + **uma linha** + botão `Ver todos` + carrossel de 4–6 empreendimentos.

| # | Componente | Linha |
|---|---|---|
| 01 | Imagens | O primeiro contacto do comprador. CGI e fotografia com a mesma direção de arte. |
| 02 | Filmes | Do teaser de lançamento ao filme institucional. Produção real, 3D ou híbrida. |
| 03 | Visitas virtuais | O comprador entra na fração antes de existir. |
| 04 | Marketing Suite | Marca, site, landing pages e plataforma de vendas num só sistema. |
| 05 | Motor de procura | Campanhas, criativos e dashboard. **Diferenciador.** |

**Distinção importante para o CMS — dois níveis de conteúdo:**

- **Empreendimento** — entrada leve: nome, localização, tipologia, componentes, imagens. Muitos. Alimentam os carrosséis.
- **Caso de estudo** — narrativa completa Desafio → Solução → Integração → Resultado, com números autorizados. Poucos (1–3 para já).

Nem todo o empreendimento é caso de estudo. Um cartão de carrossel sem caso associado deve abrir uma galeria simples, **não** uma página de caso vazia. Foi exatamente isto que a Mino não resolveu: ~42 galerias indexadas, órfãs de qualquer caminho navegável.

**Dev:** o carrossel usa `scroll-snap-type:x mandatory` e alinha o primeiro cartão à grelha via `padding-left:max(28px,calc((100vw - var(--max))/2 + 28px))`. Barra de scroll escondida. Adicionar setas ←/→ em desktop e suporte a teclado — útil quando o comercial está a apresentar sem tocar no trackpad.

---

## 4. Motor de procura

Quinto componente, visualmente distinto (`.comp.tech`, gradiente roxo). É a única coisa da oferta que nem a Mino nem a Boundary vendem — ambas param na entrega do material.

- Badge `Oferta especial · em desenvolvimento`.
- Carrossel com os quatro passos em vez de projetos: Campanhas Meta → Landing pages → Criativos → Dashboard.
- **`.motorbox`** com os requisitos do lado do cliente, em linha e compacto: equipa comercial · CRM ativo · resposta em 24 h · orçamento de media autónomo.

Enquanto estiver em desenvolvimento, **não prometer métricas nem prazos**. O badge cobre a expectativa; números por confirmar não.

---

## 5. Soluções — os três tiers

Mensagem orientada a solução, conteúdo em bundle de entregáveis. Abaixo da obra, como decidido.

| Tier | Para quem | Promessa |
|---|---|---|
| **Posicionar** | Fase de projeto | Sair do projeto com marca, posicionamento e primeiras imagens |
| **Lançar** ⭐ | Data marcada | Todo o material coerente no dia do lançamento |
| **Lançar e Vender** | Quer procura | Material + campanhas + criativos + dashboard |

- Tiers 2 e 3 abrem com `li.inh` — «Tudo o que está em X». Comunica escada sem repetir doze linhas.
- Tier 2 em destaque (`.feat2` + badge `Mais procurado`) — âncora que torna o 1 barato e o 3 aspiracional.
- Tier 3 tem `.gate` e o CTA é **`Ver se qualifica`** → `#motor`, não `Pedir proposta`.
- **Sem preços.** Nota a explicar que o orçamento é por empreendimento.

Repetir uma versão compacta dos tiers no fundo do template de caso — na Mino o bloco de preços é a unidade de conversão mais repetida do site.

---

## 6. Template de caso de estudo

Desenhado para ser apresentado, não lido. Sequência:

`hero full-bleed` → `créditos (8 campos, faixa horizontal)` → `imagem grande` → `2 imagens` → **Desafio** → **Solução** → `imagem grande` → `2 imagens (filme + visita)` → **Integração** → **Resultado + 3 números** → `citação` → **caso anterior / caso seguinte** → CTA

**Créditos — 8 campos:** Promotor · Localização · Tipologia · Unidades · Arquitetura · Componentes · Solução · Ano.

Nomear promotor e arquitetura não é vaidade: cria ligações para co-marketing e backlinks, e é a razão pela qual as páginas de caso da Boundary têm autoridade que as da Mino não têm.

**Navegação anterior/seguinte é requisito de vendas**, não decoração — permite ao comercial passar entre casos sem voltar ao índice.

> **Bloqueio:** os três números de resultado exigem autorização do cliente. Tornar a secção opcional no CMS; **não** preencher com métricas vagas.

---

## 7. Sistema visual

| Token | Valor | Uso |
|---|---|---|
| `--noite` | `#070F1B` | Fundo base |
| `--noite-2` | `#0B1728` | Secções alternadas |
| `--petroleo-lit` | `#17627B` | Coluna «sim», acentos |
| `--grafite-2` | `#212C3D` | Cartões |
| `--roxo` / `--roxo-soft` | `#7C5CFF` / `#A18BFF` | Tecnologia, motor de procura |
| `--grad` | `petroleo-lit → roxo` | CTAs primários, números, wordmark |

**Regra da cor:** roxo e gradientes concentram-se nas zonas tecnológicas — motor de procura, dashboard, V-SHOW®/MAXVIEW®. Onde a fotografia e o projeto são protagonistas — carrosséis, casos — a cor não compete: fundo neutro, sem gradiente.

- Tipografia Inter 300–600, pesos baixos em títulos grandes. Substituir pela fonte de marca quando existir.
- Hero e casos usam `veil` — gradiente de escurecimento por cima do média para o texto ler sempre.
- Breakpoint único em `1000px`. Carrosséis passam a 78vw por cartão.
- `scroll-padding-top:124px` para as âncoras não ficarem debaixo do header + barra de salto.

---

## 8. Média — o ponto crítico de performance

A página é quase toda média. Requisitos:

- Hero: vídeo `muted autoplay loop playsinline` com `poster`; **não carregar vídeo abaixo de 1000 px** — servir só o poster.
- Carrosséis: `loading="lazy"` em tudo exceto os dois primeiros cartões de cada rail.
- AVIF/WebP com `srcset` e `sizes` corretos; os cartões renderizam entre 268 e 430 px.
- Vídeos dos cartões: `poster` estático, reprodução só em hover (desktop) e nunca em mobile.
- Alvo: LCP < 2,5 s em 4G. O hero é o único risco real.

---

## 9. Formulário — qualificação

Campos: Nome* · Empresa* · Email* · Telefone · Empreendimento e localização · Nº de unidades · Fase atual · Lançamento previsto · Equipa comercial e CRM · O que precisa de resolver.

Os quatro *selects* existem para **pontuar a lead no CRM**:

| Campo | Sinal |
|---|---|
| Nº de unidades | Dimensão do ticket |
| Fase atual | Se ainda dá para trabalhar posicionamento |
| Lançamento previsto | Urgência e encaixe em agenda |
| Equipa comercial e CRM | **Qualifica ou desqualifica para o Tier 3** |

Regras sugeridas (confirmar com o comercial):

- `CRM = Nenhum dos dois` → nunca propor Tier 3.
- `Fase = Já em comercialização` **e** `Lançamento < 3 meses` → conversa de escoamento, não de lançamento.
- `Nº de unidades = Até 20` → verificar contra o limiar mínimo antes de agendar.

**Dev:** ligar ao HubSpot com submissão server-side, não com o embed. Honeypot + rate limiting. Botão: `Pedir diagnóstico`, não «Enviar» — o diagnóstico é o primeiro degrau do funil e nomeá-lo faz parte da oferta.

---

## 10. SEO e técnico — erros a não repetir

Lições diretas da auditoria Mino/Boundary:

- ✅ Title e meta description **únicos por página**. A Mino usa o mesmo title em todo o site.
- ✅ Uma única URL canónica. A Mino indexa `/` e `/home` em simultâneo.
- ✅ Slugs sem acentos, sem erros ortográficos, sem percent-encoding (`shangai-cultural-center`, `rabat-s-grnad-stadium`, `palácio-do-comércio` estão em produção na Mino).
- ✅ Páginas legais: privacidade, cookies, termos. A Mino não tem nenhuma.
- ✅ Consentimento de cookies granular — e **discreto**, porque a página é usada em reuniões.
- ✅ `Skip to main content` e navegação por teclado.
- ✅ Sem páginas órfãs. Cada empreendimento no carrossel tem de ter destino.
- Schema.org: `Organization` + `Service` na página de setor, `CreativeWork` nos casos.

---

## 11. Conteúdo em falta — bloqueia produção

| # | Item | Quem decide |
|---|---|---|
| 1 | Vídeo/imagem de hero | Marketing |
| 2 | 4–6 empreendimentos por componente, com imagens tratadas | Produção |
| 3 | **1–3 casos de estudo completos, com autorização** | Comercial / Direção |
| 4 | Números de resultado autorizados por caso | Cliente final |
| 5 | Limiar mínimo de unidades (secção de qualificação) | Comercial |
| 6 | Testemunho autorizado | Comercial |
| 7 | Logótipos de promotores com autorização de uso | Comercial |
| 8 | Prazos reais por solução (FAQ) | Produção |
| 9 | Política de propriedade de ficheiros (FAQ) | Direção |
| 10 | Descrições de V-SHOW® e MAXVIEW® | Marketing |
| 11 | Contactos comerciais e responsável | Comercial |
| 12 | Equipa: nomes, funções, fotos | RH / Marketing |

**Itens 2 e 3 são o caminho crítico.** Sem obra nos carrosséis, uma página desenhada para mostrar obra não tem nada para mostrar.

---

## 12. Fora de âmbito

- Menu mobile (hambúrguer) — só está desenhado o colapso de conteúdo.
- Landing pages de campanha do motor de procura.
- Listagem `/casos-de-estudo` filtrável — só faz sentido com volume.
- Modo de apresentação dedicado / área reservada com trabalho sob NDA — decidido **não** fazer nesta fase.
- Integração CMS e modelo de dados.
- Setas e atalhos de teclado nos carrosséis (recomendado, não prototipado).
- Restantes páginas de setor — **mas este template é o padrão para as três.**

---

## 13. Referências

- Auditoria Mino & Boundary — Notion, `Audit Mino & Boundary`
- `Clients/Viriato/projects/website-2027-revamp.md` §11, §12, §15, §16
- `Clients/Viriato/decisions/2026-07-28-estrutura-pagina-imobiliario.md`
- Launch: Imobiliário — Notion
