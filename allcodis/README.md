# 概述
```
这是编译后的可部署的codis的安装包, 不需要编译.
```

# 说明
```
codis需要centos6.5
codis依赖zookeeper
```

# 安装步骤
## 1.修改codis的配置文件config.ini
```
1.1 config.ini在codis/codisconf/下 
1.2 修改第7行zk=zookeeper集群的地址
1.3 修改第9行product=codisname, codisname自己定义, 是给codis集群起一个名字, 该名字会写入zk中
1.4 修改第14行dashboard_addr=ip:port,这是dashboard启动的ip和端口, 不要写localhost, 端口默认为18087, 建议使用默认端口
```

## 2.启动dashboard
```
cd codis
以nohup的方式启动dashboard
nohup ./bin/codis-config -c ./codisconf/config.ini dashboard > ./codislog/codisname.log 2>&1 &
log文件的名字根据实际的codisname自行修改
通过浏览器访问http://ip:18087可以访问dashboard
一个codis集群只需要启动一个dashboard
```

## 3.初始化slots
```
cd codis
./bin/codis-config -c ./codisconf/config.ini slot init
该命令会在zookeeper上创建slot相关信息
```

## 4.启动codis-server
```
codis-server就是redis改了名字.
4.1 修改codis-server的配置文件
在codis/serverconf/conf下有个server的示例配置文件,需要修改某些参数.
加入给定2台机器, 192.168.168.123,192.168.168.124, 可以在每个机器上启动2个server, 加入每个机器的server占用的端口为6900,6901
cp server.conf  server6900.conf
cp server.conf  server6901.conf
vi server6900.conf
修改如下参数
pidfile "./serverconf/pid/server6900.pid"
port 6900
bind 192.168.168.123
logfile "./serverconf/log/server6900.log"
dbfilename "dump6900.rdb"
dir "./serverconf/data"
maxmemory 15gb(根据机器的实际情况修改给server的最大内存)
4.2 其他codis-server的配置参数做类似修改
4.3 启动codis-server
./bin/codis-server ./serverconf/conf/server6900.conf
./bin/codis-server ./serverconf/conf/server6901.conf
```

## 5. 添加codis-server group
```
将codis-server实例添加到codis集群中
每一个 Server Group 作为一个 server 服务器组存在, 只允许有一个 master, 可以有多个 slave, group id 仅支持大于等于1的整数
如: 添加两个 server group, 每个 group 有两个 server 实例，group的id分别为1和2
codis-server实例为一主一从。
添加一个group，group的id为1， 并添加一个redis master到该group
./bin/codis-config server add 1 192.168.168.123:6900 master
添加一个redis slave到该group
../bin/codis-config server add 1 192.168.168.124:6901 slave
类似的，再添加group，group的id为2
../bin/codis-config server add 2 192.168.168.124:6900 master
../bin/codis-config server add 2 192.168.168.123:6901 slave
注意: master和slave不要在同一台机器上, 否则如果机器挂了,主从就都挂了
```

## 6. 给server group分配slot
```
Codis 采用 Pre-sharding 的技术来实现数据的分片, 默认分成 1024 个 slots (0-1023), 对于每个key来说, 通过以下公式确定所属的 Slot Id : SlotId = crc32(key) % 1024 每一个 slot 都会有一个特定的 server group id 来表示这个 slot 的数据由哪个 server group 来提供
如:
设置编号为[0, 511]的 slot 由 server group 1 提供服务, 编号 [512, 1023] 的 slot 由 server group 2 提供服务
./bin/codis-config slot range-set 0 511 1 online
./bin/codis-config slot range-set 512 1023 2 online
```

## 7. 启动codis-proxy
```
一个codis集群至少可以启动一个proxy, 但是为了高可用, 最好启动2个或3个
codis-proxy的配置文件在codis/proxyconf/下面
和codisconf下的配置文件一样, 只是最后一行proxy_id=proxy_1改一下, proxy_id是给proxy起的名字, 可以自定义, 名字会写入zk中
nohup ./bin/codis-proxy -c proxyconf/config.ini -L ./proxylog/proxyid.log  --cpu=2 --addr=192.168.168.123:19000 --http-addr=192.168.168.123:11000 > ./proxylog/proxyid.log 2>&1 &
proxyid根据实际情况修改
--cpu参数可以指定proxy占用的cpu的数量, 数据越大,性能越强
```

## 8. 启动codis-ha
```
codis-ha可以监控dashboard, 如果某个master挂掉, codis-ha可以自动把slave提升为master
nohup ./bin/codis-ha --codis-config=ip:18087 --productName=test &
注:ip改为dashboard的ip
	productName为dashboard的config.ini文件中的product的值 
```
	
## 9. 访问http://ip:18087
```
查看codis的监控情况. 查看proxy的状态是否为online, 如果为offline, 点击右侧的Mark Online即可
```









