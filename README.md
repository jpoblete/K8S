# K8S
Works collection
- hive:
  Implements a demo of Hive running on a single POD.
  Due to limmitations on shared storage among cluster nodes, there is no scalability.
  Otherwise, decoupling the containers would be feasible
  - To implement:
    - kubectl must be available
    - Download files from hive/base to the same directory
    - Execute: hiveCtl start
Once installed, access beeline:
```
$ kubectl exec hive -c hiveserver2 -it -- /bin/bash
[root@hive hive]# 
[root@hive hive]# /opt/hive/bin/beeline -u 'jdbc:hive2://localhost:10000/default' -n hive -p hive
...
Connecting to jdbc:hive2://localhost:10000/default
Connected to: Apache Hive (version 4.2.0)
Driver: Hive JDBC (version 4.2.0)
Transaction isolation: TRANSACTION_REPEATABLE_READ
Beeline version 4.2.0 by Apache Hive
0: jdbc:hive2://localhost:10000/default>
```
