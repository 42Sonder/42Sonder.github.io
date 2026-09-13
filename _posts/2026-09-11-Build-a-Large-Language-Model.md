---
title: "Build a Large Language Model(From Scrach)"
date: 2026-09-12 12:00:00 +0800
description: "Transformer Architecture"
keywords: "Transformer、LLM"
typora-copy-images-to: ../images/2026-09-12
typora-root-url: /Volumes/Yu2025/san/Code/42Sonder.github.io/
---

## 数学解释

设分词后序列为 $`x_1,x_2,\ldots,x_T`$。自回归语言模型把整段序列的联合概率分解为：
$$
p_\theta(x_{1:T})=\prod_{t=1}^{T}p_\theta(x_t\mid x_{<t})
$$
训练通常最小化平均负对数似然：
$$
\mathcal{L}(\theta)=-\frac{1}{T}\sum_{t=1}^{T}\log p_\theta(x_t\mid x_{<t}).
$$
