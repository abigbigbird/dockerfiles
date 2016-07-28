# ����
```
���Ǳ����Ŀɲ����codis�İ�װ��, ����Ҫ����.
```

# ˵��
```
codis��Ҫcentos6.5
codis����zookeeper
```

# ��װ����
## 1.�޸�codis�������ļ�config.ini
```
1.1 config.ini��codis/codisconf/�� 
1.2 �޸ĵ�7��zk=zookeeper��Ⱥ�ĵ�ַ
1.3 �޸ĵ�9��product=codisname, codisname�Լ�����, �Ǹ�codis��Ⱥ��һ������, �����ֻ�д��zk��
1.4 �޸ĵ�14��dashboard_addr=ip:port,����dashboard������ip�Ͷ˿�, ��Ҫдlocalhost, �˿�Ĭ��Ϊ18087, ����ʹ��Ĭ�϶˿�
```

## 2.����dashboard
```
cd codis
��nohup�ķ�ʽ����dashboard
nohup ./bin/codis-config -c ./codisconf/config.ini dashboard > ./codislog/codisname.log 2>&1 &
log�ļ������ָ���ʵ�ʵ�codisname�����޸�
ͨ�����������http://ip:18087���Է���dashboard
һ��codis��Ⱥֻ��Ҫ����һ��dashboard
```

## 3.��ʼ��slots
```
cd codis
./bin/codis-config -c ./codisconf/config.ini slot init
���������zookeeper�ϴ���slot�����Ϣ
```

## 4.����codis-server
```
codis-server����redis��������.
4.1 �޸�codis-server�������ļ�
��codis/serverconf/conf���и�server��ʾ�������ļ�,��Ҫ�޸�ĳЩ����.
�������2̨����, 192.168.168.123,192.168.168.124, ������ÿ������������2��server, ����ÿ��������serverռ�õĶ˿�Ϊ6900,6901
cp server.conf  server6900.conf
cp server.conf  server6901.conf
vi server6900.conf
�޸����²���
pidfile "./serverconf/pid/server6900.pid"
port 6900
bind 192.168.168.123
logfile "./serverconf/log/server6900.log"
dbfilename "dump6900.rdb"
dir "./serverconf/data"
maxmemory 15gb(���ݻ�����ʵ������޸ĸ�server������ڴ�)
4.2 ����codis-server�����ò����������޸�
4.3 ����codis-server
./bin/codis-server ./serverconf/conf/server6900.conf
./bin/codis-server ./serverconf/conf/server6901.conf
```

## 5. ���codis-server group
```
��codis-serverʵ����ӵ�codis��Ⱥ��
ÿһ�� Server Group ��Ϊһ�� server �����������, ֻ������һ�� master, �����ж�� slave, group id ��֧�ִ��ڵ���1������
��: ������� server group, ÿ�� group ������ server ʵ����group��id�ֱ�Ϊ1��2
codis-serverʵ��Ϊһ��һ�ӡ�
���һ��group��group��idΪ1�� �����һ��redis master����group
./bin/codis-config server add 1 192.168.168.123:6900 master
���һ��redis slave����group
../bin/codis-config server add 1 192.168.168.124:6901 slave
���Ƶģ������group��group��idΪ2
../bin/codis-config server add 2 192.168.168.124:6900 master
../bin/codis-config server add 2 192.168.168.123:6901 slave
ע��: master��slave��Ҫ��ͬһ̨������, ���������������,���ӾͶ�����
```

## 6. ��server group����slot
```
Codis ���� Pre-sharding �ļ�����ʵ�����ݵķ�Ƭ, Ĭ�Ϸֳ� 1024 �� slots (0-1023), ����ÿ��key��˵, ͨ�����¹�ʽȷ�������� Slot Id : SlotId = crc32(key) % 1024 ÿһ�� slot ������һ���ض��� server group id ����ʾ��� slot ���������ĸ� server group ���ṩ
��:
���ñ��Ϊ[0, 511]�� slot �� server group 1 �ṩ����, ��� [512, 1023] �� slot �� server group 2 �ṩ����
./bin/codis-config slot range-set 0 511 1 online
./bin/codis-config slot range-set 512 1023 2 online
```

## 7. ����codis-proxy
```
һ��codis��Ⱥ���ٿ�������һ��proxy, ����Ϊ�˸߿���, �������2����3��
codis-proxy�������ļ���codis/proxyconf/����
��codisconf�µ������ļ�һ��, ֻ�����һ��proxy_id=proxy_1��һ��, proxy_id�Ǹ�proxy�������, �����Զ���, ���ֻ�д��zk��
nohup ./bin/codis-proxy -c proxyconf/config.ini -L ./proxylog/proxyid.log  --cpu=2 --addr=192.168.168.123:19000 --http-addr=192.168.168.123:11000 > ./proxylog/proxyid.log 2>&1 &
proxyid����ʵ������޸�
--cpu��������ָ��proxyռ�õ�cpu������, ����Խ��,����Խǿ
```

## 8. ����codis-ha
```
codis-ha���Լ��dashboard, ���ĳ��master�ҵ�, codis-ha�����Զ���slave����Ϊmaster
nohup ./bin/codis-ha --codis-config=ip:18087 --productName=test &
ע:ip��Ϊdashboard��ip
	productNameΪdashboard��config.ini�ļ��е�product��ֵ 
```
	
## 9. ����http://ip:18087
```
�鿴codis�ļ�����. �鿴proxy��״̬�Ƿ�Ϊonline, ���Ϊoffline, ����Ҳ��Mark Online����
```









