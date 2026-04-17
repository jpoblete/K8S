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
