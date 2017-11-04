---
title: 机器学习(1)
date: 2017-10-20 22:22:22
categories: Machine Learning
---

## 什么是机器学习

Arthur Samuel 将其描述为：“学习领域，使计算机能够在没有被明确编程的情况下学习”。 这是一个较老的非正式的定义。

Tom Mitchell 提供了一个更现代化的<font color="red">**定义：
一个程序被认为能从经验 E 中学习，解决任务 T，达到性能度量值 P，当且仅当，有了经验 E 后，经过 P 评判，程序在处理 T 时的性能有所提升。**</font>

<!--more-->

#### Example: playing checkers.
- E = the experience of playing many games of checkers.
- T = the task of playing checkers.
- P = the probability that the program will win the next game.

一般来说，任何机器学习问题都可以分配到两个广泛的分类之一，「**监督学习**」和「**无监督学习**」。

- 监督学习是指，我们将教计算机如何去完成任务；
- 而在无监督学习中，我们打算让计算机自己进行学习。

<br/>
### 监督学习

在监督学习中，我们获得了一个数据集，并且已经知道我们正确的输出应该是什么样子的，这就意味着输入和输出之间有一个关系。

受监督的学习问题分为“回归”和“分类”问题。在回归问题中，我们试图在连续输出中预测结果，这意味着我们正在尝试将输入变量映射到一些连续函数。在分类问题中，我们试图用离散输出来预测结果。换句话说，我们正在尝试将输入变量映射到离散类别。

#### Example 1:

- Given data about the size of houses on the real estate market, try to predict their price. Price as a function of size is a continuous output, so this is a regression problem.
- We could turn this example into a classification problem by instead making our output about whether the house "sells for more or less than the asking price." Here we are classifying the houses based on price into two discrete categories.

#### Example 2:
- Regression - Given a picture of a person, we have to predict their age on the basis of the given picture
- Classification - Given a patient with a tumor, we have to predict whether the tumor is malignant or benign.

<br/>
### 无监督学习
对于监督学习中的每一个样本，我们已经被清楚地告知了什么是所谓的正确答案；

在无监督学习中，我们用的数据会和监督学习里的看起来有些不一样，没有属性或标签这一概念。也就是说所有的数据都是一样的，没有区别。

无监督学习使我们能够解决那种我们不知道结果具体应该是什么样的问题。我们可以从数据导出结构，我们没必要知道变量的影响。
我们可以通过基于数据中的变量之间的关系对数据进行聚类来导出该结构。在无监督学习的情况下，没有基于预测结果的反馈。

所以在无监督学习中，我们只有一个数据集，没人告诉我们该怎么做，我们也不知道每个数据点究竟是什么意思。相反，它只告诉我们现在有一个数据集，你能在其中找到某种结构吗？

`[W,s,v] = svd((repmat(sum(x.*x,1),size(x,1),1).*x)*x');`

<br/>
## 模型表示
先介绍一些**符号：**

- Number of training examples = \\(m\\)（训练样本数目）
- "input" variable/features = \\(x\\)'s（输入变量/特征量）
- "output" variable/"target" variable = \\(y\\)'s（输出变量/目标变量/预测结果）
- One training example = \\((x,y)\\)（一个训练样本）
- 表示<font color="red">第 \\(i\\) 个</font>训练样本使用\\((x^{(i)},y^{(i)})\\) 

>**强调！**<font color="red">这里的 \\(i\\) 不是求幂运算！</font>

**学习算法**的工作：把一个训练集喂给学习算法，然后输出一个函数 \\(h\\) (hypothesis 假设)。

>例如 \\(h\\) 是预测房价的学习算法生成的函数，将房屋尺寸大小输入给 \\(h\\)，\\(h\\) 根据输入的 \\(x\\) 值来得出 \\(y\\) 值，\\(y\\) 值对应房子的价格，因此 \\(h\\) 是一个从 \\(x\\) 到 \\(y\\) 的函数映射。

设计学习算法的时候，我们需要思考的就是如何得到这个假设 \\(h\\)。

<br/>
### 线性回归模型 linear regression
线性方程是简单的形式，所以我们将先从线性方程的例子入手，例如下面这个模型：
$$h_\theta(x)=\theta_0+\theta_1x$$
这个模型是个单变量线性回归模型，在前面说到的预测房价例子中，\\(h\\) 就是根据 \\(x\\) 来预测所有价格的函数。