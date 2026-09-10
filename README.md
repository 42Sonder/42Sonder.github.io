# My Blog

基于 [Jekyll](https://jekyllrb.com/) 的个人博客，深度定制自 [the-plain](https://github.com/heiswayi/the-plain) 主题，部署在 GitHub Pages。

## 功能一览

- 深 / 浅双主题：6:00–18:00 自动浅色，其余时间深色；右上角按钮手动切换并记忆选择
- 代码高亮：highlight.js，配色跟随主题切换
- 图片灯箱：点击文章图片放大查看（fancybox）
- 数学公式：MathJax v3（`$...$` 行内、`$$...$$` 行间）
- 浮动目录：文章自动生成可折叠 TOC
- 中英文之间自动加空格（pangu.js）
- Giscus 评论（基于 GitHub Discussions，默认关闭）
- HTML 压缩输出、Sass 压缩、sitemap、RSS

## 本地预览

需要 Ruby 3.x：

```bash
gem install bundler
bundle install
bundle exec jekyll serve
```

打开 <http://127.0.0.1:4000>。修改文件后浏览器会自动刷新。

## 写文章

在 `_posts/` 新建 `YYYY-MM-DD-文章名.md`（日期即发布日期）：

```yaml
---
title: "文章标题"
date: 2026-09-11 10:00:00 +0800   # 可省略，默认用文件名日期
description: "一句话摘要，用于搜索结果和分享卡片"
keywords: "标签一,标签二"
category: literature               # 可选，文章分类（见下节「分类页」）
---

正文用 Markdown 写。图片放在 images/2026-09-11/ 下，正文引用：
![说明文字](/images/2026-09-11/xxx.png)
```

- 文章顶部免责声明：`_config.yml` 的 `disclaimer`（留空不显示，支持 HTML）
- 数学公式开关：`_config.yml` 的 `mathjax`
- 示例文章 `_posts/2026-09-10-hello-world.md` 可留作参考或删除

## 分类页

文章通过 front matter 的 `category` 字段归类（如 `category: literature`），对应分类页 `/literature/` 会自动列出该分类的文章（按年份分组，新文章在前）。不带 `category` 的文章只出现在首页。

新增一个分类（以 `tech` 为例）只需两步：

1. 根目录新建 `tech.md`（文件名即页面路径 `/tech/`）：

   ```yaml
   ---
   layout: category
   title: Tech
   category: tech
   ---
   ```

2. `_config.yml` 的 `nav` 列表加一行导航：`- { name: "Tech", url: "/tech" }`

之后写文章时 front matter 里写 `category: tech`，文章就会自动出现在该分类页。

## 首次使用清单（部署前逐项确认）

- [ ] `_config.yml`：`title` / `author_name` / `description` / `keywords` 改成自己的
- [ ] `_config.yml`：`url` 里的 `yourusername` 替换为你的 GitHub 用户名
- [ ] `assets/avatar.jpg`：换成你的头像（建议 ≤ 200KB）
- [ ] `assets/favicon.jpeg`、`assets/touch-icon.jpeg`：换成你的站点图标
- [ ] `about.md`：自我介绍
- [ ] `friends.md`：友链（或删掉后在 `_includes/header.html` 中去掉导航入口）
- [ ] 删除或改写示例文章 `_posts/2026-09-10-hello-world.md`

## 部署到 GitHub Pages

1. 在 GitHub 创建名为 `<你的用户名>.github.io` 的**公开**仓库
2. 推送本仓库：

   ```bash
   git remote set-url origin https://github.com/<你的用户名>/<你的用户名>.github.io.git
   git push -u origin master
   ```

3. 仓库 Settings → Pages → Build and deployment → Source 选 `Deploy from a branch`，分支 `master`、目录 `/ (root)`
4. 等待 1–2 分钟，访问 `https://<你的用户名>.github.io`

之后每次写完文章：`git add . && git commit -m "new post" && git push`

## 启用评论（Giscus，可选）

1. 你的 GitHub 仓库 → Settings → General → Features → 勾选 **Discussions**
2. 安装 [giscus App](https://github.com/apps/giscus) 并授权该仓库
3. 打开 <https://giscus.app>，填入仓库名 `用户名/用户名.github.io`，
   Mapping 选 `pathname`，分类选 `Announcements`（需先在仓库 Discussions 里创建该分类），语言选中文
4. 把页面显示的 `data-repo-id`、`data-category-id` 填进 `_config.yml` 的 `giscus` 段，
   并设置 `repo: "用户名/用户名.github.io"`
5. 推送后，每篇文章底部出现评论区（评论数据存在你仓库的 Discussions 里）

## 搜索引擎收录

当前 `robots.txt` 为全站禁止抓取（低调模式）。若想被 Google / 百度收录，把：

```
Disallow: /
```

改为（冒号后留空）：

```
Disallow:
```

## 目录结构

```
├── _config.yml          # 全站配置（站点信息、导航、功能开关、Giscus）
├── _posts/              # 文章（文件名 = 日期 + 标题）
├── _layouts/            # 页面模板（compress / default / post / page / category）
├── _includes/           # 模板片段（head / header / footer / comments）
├── _sass/main.scss      # 样式源码（含自托管字体声明）
├── assets/              # 头像、图标、字体、JS
│   └── fonts/           # JetBrains Mono（woff2，自托管）
├── images/              # 文章配图（按日期建目录）
├── fancybox/            # 图片灯箱库（jQuery 插件）
├── index.html           # 首页（分页文章列表）
├── about.md / friends.md / literature.md / 404.md
├── feed.xml             # RSS
└── robots.txt           # 抓取策略（当前禁止收录）
```

## 备注

- 字体已自托管（`assets/fonts/`），不依赖 Google Fonts，国内访问无障碍
- 评论主题会跟随站点深浅模式自动切换
- 若将来更换域名：删除 `_config.yml` 中 `url` 的旧地址并在仓库根目录添加 `CNAME` 文件（内容为域名）
