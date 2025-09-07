#!/bin/bash
#!/bin/bash

for i in {1..5}
do
    echo "Number: $i"
done
# --------------------------------------------
echo -e "\n"
for i in {1..10..3}; do
    echo "Number: $i"
done
# --------------------------------------------
echo -e "\n"
for i in $(seq 1 5); do
    echo "Number: $i"
done
# --------------------------------------------
echo -e "\n"
for ((i=0; i<5; i++)); do
    echo "Index: $i"
done
