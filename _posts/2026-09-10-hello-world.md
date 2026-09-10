---
title: "Hello World：博客的第一篇文章"
date: 2026-09-10 12:00:00 +0800
description: "博客正式启用。这篇文章同时是一份写作速查表：文件命名、front matter、常用 Markdown 语法、图片与数学公式。"
keywords: "博客,写作,Markdown"
---

## 开始写吧

博客已经就绪。在 `_posts/` 目录写下你想记录的内容，`git push` 之后 GitHub Pages 会自动构建发布。

### 如何新增文章

1. 在 `_posts/` 目录新建文件，命名格式：`YYYY-MM-DD-文章名.md`
2. 文件开头写 front matter（标题必填，日期可省略——默认取文件名里的日期）
3. 正文使用 Markdown 语法
4. 提交并推送，约一分钟后线上生效

front matter 的可选字段：

```yaml
---
title: "文章标题"
date: 2026-09-11 10:00:00 +0800   # 可省略，默认用文件名日期
description: "一句话摘要，用于搜索结果和分享卡片"
keywords: "标签一,标签二"
---
```

### 常用语法速查

**文本**：*斜体*、**粗体**、`行内代码`、[链接](https://example.com)、~~删除线~~

> 引用：写给读者的一句话。

列表：

- 无序列表项
- 另一项
  - 嵌套项

表格：

| 左对齐 | 居中 | 右对齐 |
| :----- | :--: | -----: |
| a      |  b   |      c |
| 长文本 | 短   |      1 |

代码块（自动高亮）：

```python
def hello(name: str) -> str:
    return f"Hello, {name}!"

print(hello("world"))
```

图片（点击可放大；图片文件放在 `images/日期/` 目录下）：

![示例图片](/images/2026-09-10/sample.png)

数学公式（`mathjax: true` 时可用，默认已开启）：

质能方程 $E = mc^2$ 是行内公式，或者使用行间公式：

$$
\int_{-\infty}^{\infty} e^{-x^2} \, dx = \sqrt{\pi}
$$

---

更多维护说明（评论、收录、部署等）见仓库根目录的 `README.md`。
