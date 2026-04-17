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
$ kubectl exec hive -c hiveserver2 -it -- /opt/hive/bin/beeline -u 'jdbc:hive2://localhost:10000/default' -n hive -p hive 
...
Connecting to jdbc:hive2://localhost:10000/default 
Connected to: Apache Hive (version 4.2.0) 
Driver: Hive JDBC (version 4.2.0) 
Transaction isolation: TRANSACTION_REPEATABLE_READ 
Beeline version 4.2.0 by Apache Hive 
0: jdbc:hive2://localhost:10000/default> create table foo (c1 int, c2 string); 
INFO  : Compiling command(queryId=hive_20260417202718_090cef23-0888-495e-ad4e-db9015102256): create table foo (c1 int, c2 string) 
INFO  : Semantic Analysis Completed (retrial = false) 
INFO  : Created Hive schema: Schema(fieldSchemas:null, properties:null) 
INFO  : Completed compiling command(queryId=hive_20260417202718_090cef23-0888-495e-ad4e-db9015102256); Time taken: 1.144 seconds 
INFO  : Concurrency mode is disabled, not creating a lock manager 
INFO  : Executing command(queryId=hive_20260417202718_090cef23-0888-495e-ad4e-db9015102256): create table foo (c1 int, c2 string) INFO  : Starting task [Stage-0:DDL] in serial mode INFO  : Completed executing command(queryId=hive_20260417202718_090cef23-0888-495e-ad4e-db9015102256); Time taken: 0.253 seconds No rows affected (1.521 seconds) 
0: jdbc:hive2://localhost:10000/default> 
0: jdbc:hive2://localhost:10000/default> insert into foo (c1, c2) values (1, 'one'), (2, 'two'), (3, 'three');
INFO  : Compiling command(queryId=hive_20260417203149_0851f2ad-97a3-4dfc-9cb7-7538aa75a368): insert into foo (c1, c2) values (1, 'one'), (2, 'two'), (3, 'three')
INFO  : Semantic Analysis Completed (retrial = false)
INFO  : Created Hive schema: Schema(fieldSchemas:[FieldSchema(name:_col0, type:int, comment:null), FieldSchema(name:_col1, type:string, comment:null)], properties:null)
INFO  : Completed compiling command(queryId=hive_20260417203149_0851f2ad-97a3-4dfc-9cb7-7538aa75a368); Time taken: 1.028 seconds
INFO  : Concurrency mode is disabled, not creating a lock manager
INFO  : Executing command(queryId=hive_20260417203149_0851f2ad-97a3-4dfc-9cb7-7538aa75a368): insert into foo (c1, c2) values (1, 'one'), (2, 'two'), (3, 'three')
INFO  : Query ID = hive_20260417203149_0851f2ad-97a3-4dfc-9cb7-7538aa75a368
INFO  : Total jobs = 1
INFO  : Launching Job 1 out of 1
INFO  : Starting task [Stage-1:MAPRED] in serial mode
INFO  : Subscribed to counters: [] for queryId: hive_20260417203149_0851f2ad-97a3-4dfc-9cb7-7538aa75a368
INFO  : Tez session hasn't been created yet. Opening session
INFO  : Dag name: insert into foo (c1, ......o'), (3, 'three') (Stage-1)
INFO  : HS2 Host: [hive], Query ID: [hive_20260417203149_0851f2ad-97a3-4dfc-9cb7-7538aa75a368], Dag ID: [dag_1776457910470_0001_1], DAG App ID: [application_1776457910470_0001], DAG App address: [hive]
INFO  : Status: Running (Executing on YARN cluster with App id application_1776457910470_0001)----------------------------------------------------------------------------------------------
        VERTICES      MODE        STATUS  TOTAL  COMPLETED  RUNNING  PENDING  FAILED  KILLED  
----------------------------------------------------------------------------------------------
Map 1 .......... container     SUCCEEDED      1          1        0        0       0       0  
Reducer 2 ...... container     SUCCEEDED      1          1        0        0       0       0  
----------------------------------------------------------------------------------------------
VERTICES: 02/02  [==========================>>] 100%  ELAPSED TIME: 0.66 s     
----------------------------------------------------------------------------------------------
INFO  : Status: DAG finished successfully in 0.50 seconds
INFO  : DAG ID: dag_1776457910470_0001_1
INFO  : 
INFO  : Query Execution Summary
INFO  : ----------------------------------------------------------------------------------------------
INFO  : OPERATION                            DURATION
INFO  : ----------------------------------------------------------------------------------------------
INFO  : Compile Query                           1.03s
INFO  : Prepare Plan                            0.81s
INFO  : Get Query Coordinator (AM)              0.00s
INFO  : Submit Plan                             0.14s
INFO  : Start DAG                               0.04s
INFO  : Run DAG                                 0.49s
INFO  : ----------------------------------------------------------------------------------------------
INFO  : 
INFO  : Task Execution Summary
INFO  : ----------------------------------------------------------------------------------------------
INFO  :   VERTICES      DURATION(ms)   CPU_TIME(ms)    GC_TIME(ms)   INPUT_RECORDS   OUTPUT_RECORDS
INFO  : ----------------------------------------------------------------------------------------------
INFO  :      Map 1              0.00              0              0               3                1
INFO  :  Reducer 2              0.00              0              0               1                0
INFO  : ----------------------------------------------------------------------------------------------
INFO  : FileSystem Counters Summary
INFO  : 
INFO  : Scheme: FILE
INFO  : ----------------------------------------------------------------------------------------------
INFO  :   VERTICES      BYTES_READ      READ_OPS     LARGE_READ_OPS      BYTES_WRITTEN     WRITE_OPS
INFO  : ----------------------------------------------------------------------------------------------
INFO  :      Map 1              0B             0                  0                 0B             0
INFO  :  Reducer 2              0B             0                  0                 0B             0
INFO  : ----------------------------------------------------------------------------------------------
INFO  : 
INFO  : org.apache.tez.common.counters.DAGCounter:
INFO  :    NUM_SUCCEEDED_TASKS: 2
INFO  :    TOTAL_LAUNCHED_TASKS: 2
INFO  :    DURATION_SUCCEEDED_TASKS_MILLIS: 143
INFO  :    RACK_LOCAL_TASKS: 1
INFO  :    AM_CPU_MILLISECONDS: 1250
INFO  :    WALL_CLOCK_MILLIS: 143
INFO  :    AM_GC_TIME_MILLIS: 6
INFO  :    INITIAL_HELD_CONTAINERS: 0
INFO  :    TOTAL_CONTAINERS_USED: 2
INFO  :    TOTAL_CONTAINER_LAUNCH_COUNT: 2
INFO  :    TOTAL_CONTAINER_RELEASE_COUNT: 2
INFO  :    NODE_USED_COUNT: 1
INFO  :    NODE_TOTAL_COUNT: 1
INFO  : org.apache.tez.common.counters.TaskCounter:
INFO  :    SPILLED_RECORDS: 0
INFO  :    NUM_SHUFFLED_INPUTS: 0
INFO  :    NUM_FAILED_SHUFFLE_INPUTS: 0
INFO  :    INPUT_RECORDS_PROCESSED: 5
INFO  :    INPUT_SPLIT_LENGTH_BYTES: 1
INFO  :    OUTPUT_RECORDS: 1
INFO  :    APPROXIMATE_INPUT_RECORDS: 1
INFO  :    OUTPUT_LARGE_RECORDS: 0
INFO  :    OUTPUT_BYTES: 70
INFO  :    OUTPUT_BYTES_WITH_OVERHEAD: 78
INFO  :    OUTPUT_BYTES_PHYSICAL: 106
INFO  :    ADDITIONAL_SPILLS_BYTES_WRITTEN: 0
INFO  :    ADDITIONAL_SPILLS_BYTES_READ: 0
INFO  :    ADDITIONAL_SPILL_COUNT: 0
INFO  :    SHUFFLE_BYTES: 0
INFO  :    SHUFFLE_BYTES_DECOMPRESSED: 0
INFO  :    SHUFFLE_BYTES_TO_MEM: 0
INFO  :    SHUFFLE_BYTES_TO_DISK: 0
INFO  :    SHUFFLE_BYTES_DISK_DIRECT: 0
INFO  :    SHUFFLE_PHASE_TIME: 6
INFO  :    FIRST_EVENT_RECEIVED: 6
INFO  :    LAST_EVENT_RECEIVED: 6
INFO  :    DATA_BYTES_VIA_EVENT: 82
INFO  : HIVE:
INFO  :    CREATED_FILES: 2
INFO  :    DESERIALIZE_ERRORS: 0
INFO  :    RECORDS_IN_Map_1: 3
INFO  :    RECORDS_OUT_0: 1
INFO  :    RECORDS_OUT_1_default.foo: 3
INFO  :    RECORDS_OUT_INTERMEDIATE_Map_1: 1
INFO  :    RECORDS_OUT_INTERMEDIATE_Reducer_2: 0
INFO  :    RECORDS_OUT_OPERATOR_FS_15: 1
INFO  :    RECORDS_OUT_OPERATOR_FS_4: 3
INFO  :    RECORDS_OUT_OPERATOR_GBY_13: 1
INFO  :    RECORDS_OUT_OPERATOR_GBY_7: 1
INFO  :    RECORDS_OUT_OPERATOR_MAP_0: 0
INFO  :    RECORDS_OUT_OPERATOR_RS_8: 1
INFO  :    RECORDS_OUT_OPERATOR_SEL_1: 1
INFO  :    RECORDS_OUT_OPERATOR_SEL_14: 1
INFO  :    RECORDS_OUT_OPERATOR_SEL_3: 3
INFO  :    RECORDS_OUT_OPERATOR_SEL_6: 3
INFO  :    RECORDS_OUT_OPERATOR_TS_0: 1
INFO  :    RECORDS_OUT_OPERATOR_UDTF_2: 3
INFO  :    TOTAL_TABLE_ROWS_WRITTEN: 3
INFO  : Starting task [Stage-2:DEPENDENCY_COLLECTION] in serial mode
INFO  : Starting task [Stage-0:MOVE] in serial mode
INFO  : Loading data to table default.foo from file:/opt/hive/data/warehouse/foo/.hive-staging_hive_2026-04-17_20-31-49_095_5689858592842814619-1/-ext-10000
INFO  : Time taken to move files:        0 ms
INFO  : Starting task [Stage-3:STATS] in serial mode
INFO  : Executing stats task
INFO  : Table default.foo stats: [numFiles=1, numRows=3, totalSize=20, rawDataSize=17, numFilesErasureCoded=0]
INFO  : StatsTask took 108
INFO  : Completed executing command(queryId=hive_20260417203149_0851f2ad-97a3-4dfc-9cb7-7538aa75a368); Time taken: 1.656 seconds
3 rows affected (2.698 seconds)
0: jdbc:hive2://localhost:10000/default> select * from foo where c1=3;
INFO  : Compiling command(queryId=hive_20260417204701_e5397654-8b03-4e95-b1b6-b93adb81b94c): select * from foo where c1=3
INFO  : Semantic Analysis Completed (retrial = false)
INFO  : Created Hive schema: Schema(fieldSchemas:[FieldSchema(name:foo.c1, type:int, comment:null), FieldSchema(name:foo.c2, type:string, comment:null)], properties:null)
INFO  : Completed compiling command(queryId=hive_20260417204701_e5397654-8b03-4e95-b1b6-b93adb81b94c); Time taken: 0.193 seconds
INFO  : Concurrency mode is disabled, not creating a lock manager
INFO  : Executing command(queryId=hive_20260417204701_e5397654-8b03-4e95-b1b6-b93adb81b94c): select * from foo where c1=3
INFO  : Completed executing command(queryId=hive_20260417204701_e5397654-8b03-4e95-b1b6-b93adb81b94c); Time taken: 0.001 seconds
+---------+---------+
| foo.c1  | foo.c2  |
+---------+---------+
| 3       | three   |
+---------+---------+
1 row selected (0.261 seconds)
0: jdbc:hive2://localhost:10000/default> !q
Closing: 0: jdbc:hive2://localhost:10000/default
```
