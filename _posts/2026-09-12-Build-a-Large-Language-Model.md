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

### Tokenizer

- Encode 将连续的文本序列切分为具有独立语义的基本单元 token，根据词表将 token 转换位 token IDs。
- Decode 将 token IDs 转换为 token，进而转换为自然文本

### Embedding Layer

![image-20260914200821568](/images/2026-09-12/image-20260914200821568.png)

> the embddding layer is essentially a lookup operation that retrieves rows from the embedding layer’s weight matrix via a token ID.

> [!TIP]
>
> (Old View)Standard Attention modules cannot capture input sequence order—they cannot distinguish tokens at different positions.
> 初始情况下，每个向量只能编码单个 token 的信息，没有上下文信息。

### Position embeddings

- Absolute Position Encoding
  - **固定正余弦编码 (Fixed Sinusoidal Positional Encoding)**：As the sequence length increases, the frequency of the sinusoidal functions used in the positional embeddings becomes too high, resulting in very short periods. This can lead to inadequate representation of long-range dependencies and difficulties in capturing fine-grained positional information.随着序列长度的增加，位置嵌入中使用的正弦函数频率变得过高，导致周期非常短。这可能导致对长距离依赖关系的表征不足，以及捕捉细粒度位置信息的困难
  - **可学习的位置编码 (Learned Positional Encoding)**：外推性差，输入的长度受限
- Relative Position Encoding

#### Rotary Position Embedding (RoPE)

![image-20260914202335959](/images/2026-09-12/image-20260914202335959.png)

Instead of adding positional information to word embeddings, RoPE rotates **Query** and **Key** vectors through complex multiplication during attention computation.

- for 2D vector $\mathbf x=[x_1,x_2]$, rotation by angle $\theta$ is
$$
R_\theta=\begin{bmatrix}\cos\theta&-\sin\theta\\\sin\theta&\cos\theta\end{bmatrix}
$$
- for position $m$ and head dimension index $i$, we rotate by $m\theta_i$
$$
R_{m\theta}\mathbf x=\begin{bmatrix}x_1\cos(m\theta_i)-x_2\sin(m\theta_i)\\x_2\sin(m\theta_i)+x_2\cos(m\theta_i)\end{bmatrix}
$$
- in practice rather than constructing the full rotation matrix, we do element-wise multiplications
$$
\begin{bmatrix} x_1\\x_2\end{bmatrix}\odot\begin{bmatrix}\cos(m\theta)\\\cos(m\theta)\end{bmatrix}+\begin{bmatrix} -x_2\\x_1\end{bmatrix}\odot\begin{bmatrix}\sin(m\theta)\\\sin(m\theta)\end{bmatrix}
$$

RoPE uses multiple rotation speeds to capture positional information at different scales:3ec

- **Fast rotations**: Good for nearby words (short-range dependencies)
- **Slow rotations**: Good for distant words (long-range dependencies)

处理长度外推（train short, test long）：

- Positional Interpolation
- NTK-aware scaling

  ==RoPE does not require learned parameters.==

## Attention Mechanisms

### Self-Attention

### Multi-Head Self-Attention(MHA)

### KV-Cache

### Linear Attention

- DeltaNet

### Flash Attention

## LLM Architecture

![Decoder Only](/images/2026-09-12/attention-block-step.png)

> [!CAUTION]
>
> Attention：跨 token 混合信息
> FFN：token 内逐位置特征变换

### Layer Normalisation

**LayerNorm vs BatchNorm**

| 维度            | BatchNorm              | LayerNorm              |
| --------------- | ---------------------- | ---------------------- |
| 归一化方向      | batch 维度             | 特征维度               |
| 计算对象        | 同特征跨样本的均值方差 | 同样本跨特征的均值方差 |
| 依赖 batch size | 是                     | 否                     |

NLP 中序列长度不一，batch 统计不稳定，故用 LayerNorm。

- **RMSNorm**：简化计算，保证性能同时提升训练效率。（减少 Data Movement—从内存到计算单元的传输）

> Remove Bias. 同上，带来的收益通常不够大，不太值得增加额外的参数和计算

### Feed Forward Network

![GLU](/images/2026-09-12/3708248-20260604154026475-843143348.png)

![SwiGLU](/images/2026-09-12/3708248-20260604154944486-1310019537.png)
