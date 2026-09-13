# 代码库概览

## 1. 项目是什么

这是一个基于 **Jekyll** 的静态个人博客，目标部署平台是 GitHub Pages。

它没有后端服务、数据库或 API。文章和页面经过 Jekyll 构建后，会变成 HTML、CSS、JavaScript 和图片组成的静态网站。

```text
Markdown 文章 + YAML 配置
          │
          ▼
        Jekyll
          │
          ├── Liquid 模板
          ├── Sass 样式
          └── 静态资源
          │
          ▼
      生成静态网站
          │
          ▼
      GitHub Pages
```

---

## 2. 主要目录

```text
_config.yml       全站配置
_posts/           博客文章
_layouts/         页面布局模板
_includes/        可复用模板片段
_sass/            Sass 样式源码
assets/           CSS、JavaScript、字体、头像和图标
images/           文章图片
fancybox/         图片灯箱及其依赖
index.html        首页
about.md          关于页面
favorites.md      收藏页面
literature.md     Literature 分类页面
404.md            404 页面
feed.xml          RSS Feed
robots.txt        搜索引擎抓取策略
Gemfile           Ruby/Jekyll 依赖
```

`_site/` 是 Jekyll 的生成目录，当前被 `.gitignore` 忽略。它不是源代码，应以根目录下的 Markdown、模板和配置为准。

---

## 3. 内容是如何生成的

### 3.1 文章

文章放在 `_posts/`，文件名通常遵循：

```text
YYYY-MM-DD-文章名.md
```

文章由 Front Matter 和 Markdown 正文组成：

```yaml
---
title: "文章标题"
date: 2026-09-11 12:00:00 +0800
description: "文章摘要"
keywords: "关键词"
category: literature
---
```

`_config.yml` 为所有文章默认指定了 `post` 布局，因此文章会自动进入 `_layouts/post.html`。

### 3.2 布局继承

文章页面的模板关系如下：

```text
_posts/文章.md
      │
      ▼
_layouts/post.html
      │
      ▼
_layouts/default.html
      │
      ├── _includes/head.html
      ├── _includes/header.html
      └── _includes/footer.html
```

普通页面（如 `about.md`）使用 `page` 布局；分类页面（如 `literature.md`）使用 `category` 布局。它们最终都会经过 `default` 布局。

### 3.3 首页

`index.html` 使用 `default` 布局，并遍历 `paginator.posts`：

- 按年份显示文章
- 显示发布日期和标题
- 支持分页
- 每页最多显示 10 篇文章

分页数量由 `_config.yml` 中的 `paginate: 10` 控制。

---

## 4. 全站配置：`_config.yml`

这里集中定义：

- 网站标题、描述、作者和网址
- 顶部导航菜单
- 时区
- 数学公式开关
- 未来文章是否发布
- 分页数量
- Giscus 评论配置
- Jekyll 插件
- Markdown 解析方式
- Sass 压缩方式
- 页面默认布局

导航菜单来自配置：

```yaml
nav:
  - { name: "Literature", url: "/literature" }
  - { name: "Favorites", url: "/favorites" }
  - { name: "About Me", url: "/about" }
```

`_includes/header.html` 会循环读取 `site.nav`，因此增加导航项通常只需修改配置并创建对应页面。

---

## 5. 模板之间的职责

### `_layouts/compress.html`

最外层布局，用于压缩生成后的 HTML。

### `_layouts/default.html`

通用网页框架，负责：

- 引入 `head.html`
- 引入 `header.html`
- 输出页面主体 `content`
- 引入 `footer.html`
- 加载 highlight.js
- 根据主题切换代码高亮样式

### `_layouts/post.html`

文章页面负责：

- 标题和日期
- 免责声明
- 正文
- 上一篇、下一篇和首页导航
- Giscus 评论区

### `_layouts/page.html`

普通页面的标题、正文和返回首页链接。

### `_layouts/category.html`

根据 `page.category` 筛选 `site.categories`，按年份列出文章。

---

## 6. `_includes/` 模板片段

### `head.html`

生成 `<head>` 内容，包括：

- 页面标题
- description、keywords、author
- Open Graph 和 Twitter 分享信息
- favicon 和 Apple Touch Icon
- 代码高亮 CSS
- Fancybox CSS
- `assets/core.css`
- canonical URL 和 RSS 链接
- 可选的 MathJax

### `header.html`

显示：

- 深浅色主题切换按钮
- 作者头像
- 作者名称
- 配置中的导航菜单

### `footer.html`

显示版权信息，并加载：

- jQuery
- TOC 脚本
- Fancybox
- pangu.js

它还会将文章图片包装成 Fancybox 链接。

### `comments.html`

如果 `_config.yml` 配置了 Giscus 仓库，就嵌入 Giscus 评论组件。评论实际存储在 GitHub Discussions 中。

---

## 7. 样式系统

`assets/core.scss` 是 Sass 入口：

```scss
@import 'main';
```

它引入 `_sass/main.scss`，Jekyll 最终生成：

```text
assets/core.css
```

样式负责：

- 页面颜色和排版
- 文章宽度
- 导航和页脚
- 代码块和表格
- 图片和引用
- 评论区
- 文章目录
- 响应式布局
- 深色模式

字体 JetBrains Mono 已经放在 `assets/fonts/` 中自托管，不依赖 Google Fonts。

---

## 8. 深色 / 浅色模式

逻辑位于 `assets/js/theme.js`。

初始化时：

1. 优先读取浏览器 `localStorage` 中保存的主题。
2. 如果没有保存过，06:00–18:00 使用浅色，其他时间使用深色。
3. 把主题写入：

   ```html
   <html data-theme="dark">
   ```

4. Sass 使用 `[data-theme="dark"]` 覆盖颜色变量。
5. 用户点击按钮后切换主题并保存选择。

代码高亮也会同步切换：

```text
github.min.css       浅色代码高亮
github-dark.min.css  深色代码高亮
```

Giscus 评论 iframe 的主题也会随站点主题更新。

---

## 9. 浏览器端功能

### `assets/js/toc.js`

文章加载后查找 `h2`、`h3`、`h4`，自动生成右侧目录。

支持：

- 目录折叠
- 点击标题平滑滚动
- 根据滚动位置高亮当前标题

目录在屏幕宽度小于等于 1200px 时隐藏。

### highlight.js

Jekyll 本身关闭了代码高亮，改由浏览器端 highlight.js 处理 Markdown 代码块。

### pangu.js

自动在中文和英文、数字之间添加合适空格，改善排版。

### Fancybox

点击文章图片时弹出放大查看窗口。

### MathJax

当 `_config.yml` 中 `mathjax: true` 时，页面加载 MathJax，支持 `$...$` 和 `$$...$$` 公式。

---

## 10. 分类、RSS 和搜索引擎

### 分类

文章设置：

```yaml
category: literature
```

就会出现在 `/literature/` 页面。

当前 `literature.md` 已经存在，但当前文章没有设置 `category: literature`，因此该分类页可能为空。

### RSS

`feed.xml` 遍历 `site.posts`，生成 RSS，供 RSS 阅读器订阅。

### Sitemap

`jekyll-sitemap` 插件自动生成 sitemap。

### robots.txt

当前内容是：

```text
User-agent: *
Disallow: /
```

这会禁止搜索引擎抓取全站。

---

## 11. 图片

文章图片放在 `images/` 下，通常按日期分目录：

```text
images/
├── 2026-09-10/
└── 2026-09-11/
```

推荐使用网站根路径引用：

```markdown
![说明](/images/2026-09-11/example.png)
```

当前 `2026-09-11-Hopper.md` 的第一张图片使用了相对路径：

```markdown
![图片](images/2026-09-11/xxx.png)
```

在文章页面中可能被解析成错误路径，建议统一改为以 `/images/` 开头的根路径。

---

## 12. 部署和本地运行

依赖由 `Gemfile` 定义，主要包括：

- Jekyll
- jekyll-sitemap
- jekyll-paginate
- ffi

通常可以使用：

```bash
bundle install
bundle exec jekyll serve
```

然后访问：

```text
http://127.0.0.1:4000
```

推送到 GitHub 后，GitHub Pages 会自动构建和发布。

---

## 13. 当前状态和注意事项

### `_site/` 内容过期

当前 `_site/` 中还能看到旧博客的文章、作者名和目录结构。它是旧的构建产物，而且已被 `.gitignore` 忽略。

分析当前项目时，应以源文件为准，而不是 `_site/`。

### 本地构建问题

执行：

```bash
bundle exec jekyll build
```

当前因本地 Ruby 依赖中的原生 `google-protobuf` 扩展无法加载而失败：

```text
cannot load such file -- google/protobuf_c
```

这更像是本地 Ruby/Bundler 依赖或平台架构问题，不代表模板逻辑一定有错误。

---

## 14. 新增文章的完整流程

```text
1. 在 _posts/ 创建 YYYY-MM-DD-文章名.md
          │
2. 写 Front Matter 和 Markdown 正文
          │
3. Jekyll 读取 _config.yml
          │
4. Markdown 被转换成 HTML
          │
5. 文章套用 post.html
          │
6. post.html 套用 default.html
          │
7. default.html 插入 head/header/footer
          │
8. Sass 编译成 CSS
          │
9. GitHub Pages 发布静态文件
```

访问者打开网页后，浏览器再执行主题切换、目录、代码高亮、图片灯箱、数学公式和评论等功能。

---

## 总结

这个项目可以理解成一个“用 Markdown 写内容、用模板拼页面、用 Jekyll 生成静态网站”的博客系统：

- Markdown 是内容来源
- `_config.yml` 是全站配置中心
- `_layouts/` 决定页面结构
- `_includes/` 提供公共组件
- Sass 决定页面外观
- JavaScript 提供交互
- GitHub Pages 负责发布
- Giscus 提供评论
- 没有数据库，也没有运行中的后端服务器
