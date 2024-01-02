# Linux文件传输的三种方式


## 1 nc命令

执行如下命令，在目标机器(假设ip为`10.11.12.13`)上监听端口`8415`
```
nc -l 8415 &gt; data.txt
```

往目标机器发送数据 
```
nc -v 10.11.12.13 8415 &lt; ~/Downloads/data.txt
```

## 2 SimpleHTTPServer

在服务器(假设ip为`10.11.12.13`)上执行如下命令: 
```
python -m SimpleHTTPServer 8411 
```
然后在本地机器打开浏览器，输入`http://10.11.12.13:8411/`可以访问。

## 3 scp命令

Linux scp命令用于Linux之间复制文件和目录。

scp是 secure copy的缩写, scp是linux系统下基于ssh登陆进行安全的远程文件拷贝命令。

在目标机器执行如下命令： 
```
scp -l 700000 username@dev.test.com:~/data.txt ./ 
```
即可把目标机器dev.test.com的文件~/data.txt拷贝到当前目录。

---

> 作者:   
> URL: https://xzygis.github.io/posts/three-ways-to-transfer-files-in-linux/  

