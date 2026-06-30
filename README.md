SAX-VSM website
===============

Source for the SAX-VSM project site, published at
<https://jmotif.github.io/sax-vsm_site/>.
For the library itself see <https://github.com/jMotif/sax-vsm_classic>.

Built with [Hugo](https://gohugo.io/) (extended). The previous Jekyll/Morea
stack has been retired — content now lives as plain Markdown under `content/`.
Shares its design system (`assets/css/main.css`) with the GrammarViz site; the
accent color is selected via `params.accent = "saxvsm"` in `hugo.toml`.

Layout
------

```
hugo.toml              site config (baseURL is the GitHub Pages subpath)
content/               page content (Markdown)
  _index.md              home
  algorithm/             the primer: znorm, PAA, SAX, tf·idf, cosine, SAX-VSM …
  patterns/              motif/discord discovery
assets/css/main.css    the design system (shared with GrammarViz)
layouts/               templates, partials, shortcodes, render hooks
static/images/         figures (and cp95.pdf)
```

Develop & build
---------------

```
hugo server            # live preview at http://localhost:1313/sax-vsm_site/
hugo --gc --minify     # static site emitted to public/
```

GitHub Pages serves the `gh-pages` branch; publish by pushing the contents of
`public/` there. Do not edit `gh-pages` by hand.

Writing content
---------------

- Figures: `{{< fig src="name.png" w="800" alt="…" >}}` (images in `static/images/`).
- Math: `$$ … $$` (display) and `\( … \)` (inline); MathJax auto-loads on pages with math.
- Cross-page links use `{{< ref "/algorithm/sax" >}}`.
- The algorithm primer is ordered by each page's `weight`.
