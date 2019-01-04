# RMarkdown: Inserting Page Breaks in MS Word

**This requires Pandoc 2.0 which should come installed with RStudio 1.2 (currently only available as a preview version and does not support 32-bit R)**

Download this [lua](https://pandoc.org/lua-filters.html) file: https://github.com/pandoc/lua-filters/blob/master/pagebreak/pagebreak.lua

Put the lua file in the same folder as your Rmd file.

The YAML header in the Rmd file should refer to the lua file in the `pandoc_args` (note that the indenting in the YAML is important):

```{r}
---
title: "Untitled"
author: "Me"
date: "December 20, 2018"
output:
  word_document:
    pandoc_args:
      --lua-filter=pagebreak.lua
---
```

Insert page breaks where you want by typing `\newpage`.
