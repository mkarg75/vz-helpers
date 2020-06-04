#!/bin/bash

for node in $(oc get nodes | grep ^worker | awk '{print $1}')
do
        oc label node $node placement=logtest
done


