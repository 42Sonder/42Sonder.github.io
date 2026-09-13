---
title: "Build a Large Language Model(From Scrach)"
date: 2026-09-12 12:00:00 +0800
description: "Transformer Architecture"
keywords: "Transformer、LLM"
typora-copy-images-to: ../images/2026-09-12
typora-root-url: /Volumes/Yu2025/san/Code/42Sonder.github.io/

---

![MAP](/images/2026-09-12/design-decisions.png)

## 1. Understanding LLM

> when we say language models “understand,” we mean that they can process and generate text in ways that appear coherent and contextually relevant, not that they possess human-like consciousness or comprehension.

![Transformer](/images/2026-09-12/4_3_1.svg)

- Cross-Attention Layer（交叉注意力层）：Key 和 Value 来自于编码器（Encoder）的最终输出，而 Query 则来自与解码器 (Decoder) 的输出，这使得 Decoder 在生成每个词时，能够关注 Encoder 编码的整个输入序列。

## 数学解释

设分词后序列为 $x_1,x_2,\ldots,x_T$。自回归语言模型把整段序列的联合概率分解为：

$$
p_\theta(x_{1:T})=\prod_{t=1}^{T}p_\theta(x_t\mid x_{<t})
$$

训练通常最小化平均负对数似然：

$$
\mathcal{L}(\theta)=-\frac{1}{T}\sum_{t=1}^{T}\log p_\theta(x_t\mid x_{<t}).
$$

## Embedding

将非数值数据（文本、图像、视频、音频）映射到连续向量空间。

| 方法     | 问题                                   |
| -------- | -------------------------------------- |
| One-Hot  | 丢失相似性关系，无法度量词间相似度     |
| Word2Vec | 静态向量，一词一义，无法捕捉长距离依赖 |

> 对于词典中的任意一个词，Word2Vec 只会生成一个固定的向量表示。这个向量是在整个语料库上训练得到的“平均”语义，与该词出现的具体上下文无关。这直接导致了 Word2Vec 无法解决一词多义的问题。它只能捕捉到局部共现关系，而无法理解长距离的依赖。

- **BPE** (Byte Pair Encoding)：解决 OOV 问题，减小词表，促进泛化

> 动态嵌入的优势：与 Word2Vec 不同，LLM 中的嵌入随任务和数据联合优化。
> The advantage of optimizing the embeddings as part of the LLM training instead of using Word2Vec is that the embeddings are optimized to the specific task and data at hand. 动态编码，每次可以根据输入动态变化 embedding

## Attention Mechanisms

## LLM Architecture

![Decoder Only](/images/2026-09-12/attention-block-step.png)
