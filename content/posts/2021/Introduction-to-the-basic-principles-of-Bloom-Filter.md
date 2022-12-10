---
title: '浅谈Bloom Filter基本原理及使用方式'
date: 2021-06-12 16:22:56
tags: ["bloom filter"]
categories: ["后台开发"]
---

一提到元素查找，我们会很自然的想到`HashMap`。通过将哈希函数作用于key上，我们得到了哈希值，基于哈希值我们可以去表里的相应位置获取对应的数据。除了存在哈希冲突问题之外，`HashMap`一个很大的问题就是空间效率低。引入`Bloom Filter`则可以很好的解决空间效率的问题。



## 原理
Bloom Filter是一种空间效率很高的随机数据结构，Bloom filter 可以看做是对bit-map 的扩展，布隆过滤器被设计为一个具有N的元素的位数组A（bit array），初始时所有的位都置为0。

当一个元素被加入集合时，通过K个Hash函数将这个元素映射成一个位阵列（Bit array）中的K个点，把它们置为1。检索时，我们只要看看这些点是不是都是1就（大约）知道集合中有没有它了。

- 如果这些点有任何一个 0，则被检索元素一定不在；
- 如果都是 1，则被检索元素很可能在。


## 添加元素
要添加一个元素，我们需要提供k个哈希函数。每个函数都能返回一个值，这个值必须能够作为位数组的索引（可以通过对数组长度进行取模得到）。然后，我们把位数组在这个索引处的值设为1。例如，第一个哈希函数作用于元素I上，返回x。类似的，第二个第三个哈希函数返回y与z，那么：
`A[x]=A[y]=A[z] = 1`

## 查找元素
查找的过程与上面的过程类似，元素将会被会被不同的哈希函数处理三次，每个哈希函数都返回一个作为位数组索引值的整数，然后我们检测位数组在x、y与z处的值是否为1。如果有一处不为1，那么就说明这个元素没有被添加到这个布隆过滤器中。如果都为1，就说明这个元素在布隆过滤器里面。当然，会有一定误判的概率。

## 算法优化
通过上面的解释我们可以知道，如果想设计出一个好的布隆过滤器，我们必须遵循以下准则：

- 好的哈希函数能够尽可能的返回宽范围的哈希值。
- 位数组的大小（用m表示）非常重要：如果太小，那么所有的位很快就都会被赋值为1，这样就增加了误判的几率。
- 哈希函数的个数（用k表示）对索引值的均匀分配也很重要。

计算m的公式如下：
`m = - nlog p / (log2)^2`
这里p为可接受的误判率。

计算k的公式如下：
`k = m/n log(2)`
这里k=哈希函数个数，m=位数组个数，n=待检测元素的个数（后面会用到这几个字母）。

## 哈希算法
哈希算法是影响布隆过滤器性能的地方。我们需要选择一个效率高但不耗时的哈希函数，在论文《更少的哈希函数，相同的性能指标：构造一个更好的布隆过滤器》中，讨论了如何选用2个哈希函数来模拟k个哈希函数。首先，我们需要计算两个哈希函数h1(x)与h2(x)。然后，我们可以用这两个哈希函数来模仿产生k个哈希函数的效果：
`gi(x) = h1(x) + ih2(x)`
这里i的取值范围是1到k的整数。

Google Guava类库使用这个技巧实现了一个布隆过滤器，哈希算法的主要逻辑如下：
```java
long hash64 = ...;
int hash1 = (int) hash64;
int hash2 = (int) (hash64 >>> 32);

for (int i = 1; i <= numHashFunctions; i++) {
  int combinedHash = hash1 + (i * hash2);
  // Flip all the bits if it's negative (guaranteed positive number)
  if (combinedHash < 0) {
    combinedHash = ~combinedHash;
  }
}
```

Guava中的Bloom Filter使用示例：
```java
int expectedInsertions = ...; //待检测元素的个数
double fpp = 0.03; //误判率(desired false positive probability)
BloomFilter<CharSequence> bloomFilter = BloomFilter.create(Funnels.stringFunnel(Charset.forName("UTF-8")), expectedInsertions,fpp);
```

## 优点
它的优点是空间效率和查询时间都远远超过一般的算法，布隆过滤器存储空间和插入/查询时间都是常数O(k)。另外, 散列函数相互之间没有关系，方便由硬件并行实现。布隆过滤器不需要存储元素本身，在某些对保密要求非常严格的场合有优势。

## 缺点
布隆过滤器的缺点和优点一样明显，误算率是其中之一。

另外，一般情况下不能从布隆过滤器中删除元素。我们很容易想到把位数组变成整数数组，每插入一个元素相应的计数器加 1，这样删除元素时将计数器减掉就可以了。然而要保证安全地删除元素并非如此简单。首先我们必须保证删除的元素的确在布隆过滤器里面，而这一点单凭这个过滤器是无法保证的。

参考来源：

- https://www.javacodegeeks.com/2014/07/how-to-use-bloom-filter-to-build-a-large-in-memory-cache-in-java.html
- https://www.cnblogs.com/haippy/archive/2012/07/13/2590351.html
- https://segmentfault.com/a/1190000002729689