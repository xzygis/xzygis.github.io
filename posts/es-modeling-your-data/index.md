# ES数据建模之关联关系处理



现实世界有很多重要的关联关系：博客帖子有一些评论，银行账户有多次交易记录，客户有多个银行账户，订单有多个订单明细，文件目录有多个文件和子目录。

## 内部对象数组
考虑包含内部对象的数组是如何被索引的。 假设我们有个 followers 数组：
```json
{
  &#34;followers&#34;: [
    { &#34;age&#34;: 35, &#34;name&#34;: &#34;Mary White&#34;},
    { &#34;age&#34;: 26, &#34;name&#34;: &#34;Alex Jones&#34;},
    { &#34;age&#34;: 19, &#34;name&#34;: &#34;Lisa Smith&#34;}
  ]
}
```
这个文档会像我们之前描述的那样被扁平化处理，结果如下所示：
```json
{
    &#34;followers.age&#34;:    [19, 26, 35],
    &#34;followers.name&#34;:   [alex, jones, lisa, smith, mary, white]
}
```
`{age: 35}` 和 `{name: Mary White}` 之间的相关性已经丢失了，因为每个多值域只是一包无序的值，而不是有序数组。

## 嵌套对象
由于在 Elasticsearch 中单个文档的增删改都是原子性操作,那么将相关实体数据都存储在同一文档中也就理所当然。 比如说,我们可以将订单及其明细数据存储在一个文档中。又比如,我们可以将一篇博客文章的评论以一个 comments 数组的形式和博客文章放在一起：
```json
PUT /my_index/blogpost/1
{
  &#34;title&#34;: &#34;Nest eggs&#34;,
  &#34;body&#34;:  &#34;Making your money work...&#34;,
  &#34;tags&#34;:  [ &#34;cash&#34;, &#34;shares&#34; ],
  &#34;comments&#34;: [ 
    {
      &#34;name&#34;:    &#34;John Smith&#34;,
      &#34;comment&#34;: &#34;Great article&#34;,
      &#34;age&#34;:     28,
      &#34;stars&#34;:   4,
      &#34;date&#34;:    &#34;2014-09-01&#34;
    },
    {
      &#34;name&#34;:    &#34;Alice White&#34;,
      &#34;comment&#34;: &#34;More like this please&#34;,
      &#34;age&#34;:     31,
      &#34;stars&#34;:   5,
      &#34;date&#34;:    &#34;2014-10-22&#34;
    }
  ]
}
```
如果我们依赖字段自动映射,那么 comments 字段会自动映射为 object 类型。

由于所有的信息都在一个文档中,当我们查询时就没有必要去联合文章和评论文档,查询效率就很高。但是因为JSON 格式的文档被处理成如下的扁平式键值对的结构，会导致查询结果不准确。
```json
{
  &#34;title&#34;:            [ eggs, nest ],
  &#34;body&#34;:             [ making, money, work, your ],
  &#34;tags&#34;:             [ cash, shares ],
  &#34;comments.name&#34;:    [ alice, john, smith, white ],
  &#34;comments.comment&#34;: [ article, great, like, more, please, this ],
  &#34;comments.age&#34;:     [ 28, 31 ],
  &#34;comments.stars&#34;:   [ 4, 5 ],
  &#34;comments.date&#34;:    [ 2014-09-01, 2014-10-22 ]
}
```

嵌套对象 就是来解决这个问题的。将 comments 字段类型设置为 nested 而不是 object 后,每一个嵌套对象都会被索引为一个 隐藏的独立文档 ,举例如下:
```json
{ 
  &#34;comments.name&#34;:    [ john, smith ],
  &#34;comments.comment&#34;: [ article, great ],
  &#34;comments.age&#34;:     [ 28 ],
  &#34;comments.stars&#34;:   [ 4 ],
  &#34;comments.date&#34;:    [ 2014-09-01 ]
}
{ 
  &#34;comments.name&#34;:    [ alice, white ],
  &#34;comments.comment&#34;: [ like, more, please, this ],
  &#34;comments.age&#34;:     [ 31 ],
  &#34;comments.stars&#34;:   [ 5 ],
  &#34;comments.date&#34;:    [ 2014-10-22 ]
}
{ 
  &#34;title&#34;:            [ eggs, nest ],
  &#34;body&#34;:             [ making, money, work, your ],
  &#34;tags&#34;:             [ cash, shares ]
}
```
第一个和第二个为嵌套文档，第三个为根文档。

在独立索引每一个嵌套对象后,对象中每个字段的相关性得以保留。我们查询时,也仅仅返回那些真正符合条件的文档。

不仅如此,由于嵌套文档直接存储在文档内部,查询时嵌套文档和根文档联合成本很低,速度和单独存储几乎一样。

嵌套文档是隐藏存储的,我们不能直接获取。如果要增删改一个嵌套对象,我们必须把整个文档重新索引才可以。值得注意的是,查询的时候返回的是整个文档,而不是嵌套文档本身。

## 父-子关系文档
父-子关系文档 在实质上类似于 nested model（嵌套对象） ：允许将一个对象实体和另外一个对象实体关联起来。而这两种类型的主要区别是：在 nested objects 文档中，所有对象都是在同一个文档中，而在父-子关系文档中，父对象和子对象都是完全独立的文档。

父-子关系的主要作用是允许把一个 type 的文档和另外一个 type 的文档关联起来，构成一对多的关系：一个父文档可以对应多个子文档 。与 nested objects 相比，父-子关系的主要优势有：

- 更新父文档时，不会重新索引子文档。
- 创建，修改或删除子文档时，不会影响父文档或其他子文档。这一点在这种场景下尤其有用：子文档数量较多，并且子文档创建和修改的频率高时。
- 子文档可以作为搜索结果独立返回。

- Elasticsearch 维护了一个父文档和子文档的映射关系，得益于这个映射，父-子文档关联查询操作非常快。但是这个映射也对父-子文档关系有个限制条件：父文档和其所有子文档，都必须要存储在同一个分片中。




---

> 作者:   
> URL: https://xzygis.github.io/posts/es-modeling-your-data/  

