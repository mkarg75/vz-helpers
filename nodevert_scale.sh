#!/bin/bash


# Edit these
export PODS_PER_NODE=200
export NODEVERTICAL_NODE_COUNT=15
#export NODEVERTICAL_NODE_COUNT=117
export NODEVERTICAL_STEPSIZE=50
export NODEVERTICAL_PAUSE=30
export NODEVERTICAL_TS_TIMEOUT=600

# Presets and calculated values
export NODEVERTICAL_TEST_PREFIX=nodevertical_${NODEVERTICAL_NODE_COUNT}
export NODEVERTICAL_BASENAME=nodevertical-rerun-1
export NODEVERTICAL_CLEANUP=true
export NODEVERTICAL_POD_IMAGE="gcr.io/google_containers/pause-amd64:3.0"
# Max pods calculated from pod density and node count
export NODEVERTICAL_MAXPODS=$(echo "$PODS_PER_NODE * $NODEVERTICAL_NODE_COUNT" | bc)
# 50 pods take up to 3 minutes to get to running state, which
# comes to about 3.6 seconds per pod, so rounding up to 4 seconds
export EXPECTED_NODEVERTICAL_DURATION=$(echo "$NODEVERTICAL_MAXPODS * 4" | bc)
# There is roughly a 10 second delay between polls, so the
# number of polls should be the duration / 10
export JOB_COMPLETION_POLL_ATTEMPTS=$(printf %.0f $(echo "$EXPECTED_NODEVERTICAL_DURATION / 10" | bc))


starttime=$(date +%s%N | cut -b1-13)
time ansible-playbook -i inventory workloads/nodevertical.yml
endtime=$(date +%s%N | cut -b1-13)

echo Start $starttime >> /tmp/nodevert_${NODEVERTICAL_NODE_COUNT}.log
echo Endtime $enddtime >> /tmp/nodevert_${NODEVERTICAL_NODE_COUNT}.log

# create annotations in all the dasbhoards
for dashid in 1 2 3 4; do
curl -H "Content-Type: application/json" -X POST -d "{\"dashboardId\":${dashid},\"time\":${starttime},\"isRegion\":\"true\",\"timeEnd\":${endtime},\"tags\":[\"${NODEVERTICAL_TEST_PREFIX}\"],\"text\":\"${NODEVERTICAL_NODE_COUNT} nodes - Nodevertical test - ${NODEVERTICAL_MAXPODS} maxpods\"}" http://admin:admin@dittybopper-dittybopper.apps.$(oc cluster-info | head -1 | awk -F. '{print $2}').myocp4.com/api/annotations
done

