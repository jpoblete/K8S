#!/bin/bash
#
# Script to create a table with or without partitioning with fake data
# Instructions....
# * On the HiveServer2 node, download the createTable.sh script to a directory of your choosing
# * Grant execution: chmod +x ./createTable.sh
# * Setup the kerberos environment - if applicable
# * Execute the script - it will invoke beeline
#   ./createTable.sh ext dummy_3_1 3 1 10 10
#   In this example, it will create...
#   Type        : external
#   Table       : dummy_3_1 
#   Columns     : 3
#   Partitioning: 1 level
#   Rows        : 10 per partition
#   Partitions  : 10
# IMPORTANT: Action takes place in this line:
# beeline -f /tmp/createTable.${TIMESTAMP}.hql
# Be sure to add your JDBC string as needed
#
TIMESTAMP=$(date "+%s")
TBL_TYPE=$1    # Type: ext (external) / man (managed)
TBL_NAME=$2    # Table name
TBL_COLS=$3    # Number of columns
PRT_COUNT=$4   # Partition level
ROW_PART=$5    # Rows/ partition
ITERATIONS=$6  # Total number of partitions - if Partition level >= 1

usage(){
echo "createTable.sh table_type table_name cols_number part_number rows iterations"
echo "table_type  : ext, man - i.e external / managed"
echo "table_name  : choose a table name that does not exist already"
echo "cols_number : number of columns"
echo "part_number : number of nested partitions"
echo "rows        : rows per partition"
echo "iterations  : number of partitions to be created"
}

[  -z "${TBL_TYPE}"    ] && echo "ERROR: table_type needs to be either 'man' or 'ext'"          && usage && exit 1
[  -z "${TBL_NAME}"    ] && echo "ERROR: table_name needs to be specified"                      && usage && exit 1
[  -z "${TBL_COLS}"    ] && echo "INFO : cols_number is undefined, defaulting to cols_number=2" && TBL_COLS=2
[  "${TBL_COLS}" -lt 2 ] && echo "ERROR: cols_number=${TBL_COLS}, cannot be less than 2"        && usage && exit 1
[  -z "${PRT_COUNT}"   ] && echo "INFO : part_number is undefined, defaulting to part_number=0" && PRT_COUNT=0
[  -z "${ROW_PART}"    ] && echo "INFO : rows is undefined, defaulting to rows=10"              && ROW_PART=10
[  -z "${ITERATIONS}"  ] && echo "INFO : iterations is undefined, defaulting to iteration=10"   && ITERATIONS=10

# Performance helper: Generates an alphanumeric string entirely in-memory
genRandomStr() {
    local len=$1
    local s=""
    local chars='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    while (( ${#s} < len )); do
        s+="${chars:RANDOM%62:1}"
    done
    echo "$s"
}
createTbl(){
STATEMENT="CREATE "
[ "${TBL_TYPE}" == "ext" ] && STATEMENT="${STATEMENT} EXTERNAL"
STATEMENT="${STATEMENT} TABLE IF NOT EXISTS ${TBL_NAME} ( c1 int,"
((TBL_COLS--))
for i in $(seq 2 ${TBL_COLS}); do
STATEMENT="${STATEMENT} c${i} string, "
done
((TBL_COLS++))
STATEMENT="${STATEMENT} c${TBL_COLS} string )"
if [ "${PRT_COUNT}" -gt 0 ]; then
STATEMENT="${STATEMENT} PARTITIONED BY ("
((PRT_COUNT--))
for i in $(seq 1 ${PRT_COUNT}); do
STATEMENT="${STATEMENT} p${i} int, "
done
((PRT_COUNT++))
STATEMENT="${STATEMENT} p${PRT_COUNT} int )"
else
STATEMENT="${STATEMENT}"
fi
STATEMENT="${STATEMENT} CLUSTERED BY (c1) SORTED BY (c1 ASC) INTO 128 BUCKETS;"
echo ${STATEMENT}
}
genData(){
STATEMENT="INSERT INTO ${TBL_NAME} ("
((TBL_COLS--))
#
# Columns
#
for i in $(seq 1 ${TBL_COLS}); do
STATEMENT="${STATEMENT} c${i},"
done
((TBL_COLS++))
STATEMENT="${STATEMENT} c${TBL_COLS}"
#
# Partitions
#
if [ "${PRT_COUNT}" -gt 0 ]; then
STATEMENT="${STATEMENT},"
((PRT_COUNT--))
for i in $(seq 1 ${PRT_COUNT}); do
STATEMENT="${STATEMENT} p${i},"
done
((PRT_COUNT++))
STATEMENT="${STATEMENT} p${PRT_COUNT} )"
else
STATEMENT="${STATEMENT} )"
fi
#
# Creating fake dataset per partition
# Column Data per partition
# First column is always INT
# Next are random 15 char strings
#
# RowData
#
#echo "Line 71: PRT_COUNT=${PRT_COUNT}"
STATEMENT="${STATEMENT} VALUES ("
iteration=0
plist=()
for r in $(seq 1 ${ROW_PART}); do
vals="${r},"
#data=$(tr -dc A-Za-z0-9 </dev/urandom 2>/dev/null| head -c 15)
data=$(genRandomStr 15)
((TBL_COLS--))
for i in $(seq 2 ${TBL_COLS}); do
vals="${vals} '${data}', "
done
((TBL_COLS++))
vals="${vals} '${data}'"
STATEMENT="${STATEMENT} ${vals}"
#
# PartitionData
#
#echo ${STATEMENT}
if [ "${PRT_COUNT}" -ge 1 ]; then
STATEMENT="${STATEMENT},"
#echo "iteration=${iteration}"
#plist=()
if [ "${iteration}" -eq 0 ]; then
#echo "Random partitions: ${PRT_COUNT}"
for i in $(seq 1 ${PRT_COUNT}); do
plist=("${plist[@]}" "${RANDOM}")
done
((iteration++))
#echo "End Random partitions"
fi
for p in "${plist[@]}"; do
STATEMENT="${STATEMENT} ${p}, "
done
STATEMENT="${STATEMENT::-2}"
STATEMENT="${STATEMENT} ), ("
#echo "Line 104"
else
STATEMENT="${STATEMENT} )"
[ "${r}" -lt "${ROW_PART}" ] && STATEMENT="${STATEMENT}, ("
fi
((r++))
done
STATEMENT=${STATEMENT::-3}
STATEMENT="${STATEMENT};"
echo "${STATEMENT}"
}

main(){
createTbl
if [ "${ITERATIONS}" -gt 1 ]; then
for i in $(seq 1 ${ITERATIONS}); do
genData
done
fi
}

main | tee -a /tmp/createTable.${TIMESTAMP}.hql
beeline -f /tmp/createTable.${TIMESTAMP}.hql
#EOF
