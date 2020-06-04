#!/bin/bash

export MASTERVERTICAL_TEST_PREFIX=mastervertical_117
export MASTERVERTICAL_CLEANUP=true
export MASTERVERTICAL_BASENAME=mastervertical
export MASTERVERTICAL_PROJECTS=468
export EXPECTED_MASTERVERTICAL_DURATION=345600
export JOB_COMPLETION_POLL_ATTEMPTS=34560                       # 10 times less than the expected duration, since the pull interval is 10 seconds

starttime=$(date +%s%N | cut -b1-13)
time ansible-playbook -i inventory workloads/mastervertical.yml
endtime=$(date +%s%N | cut -b1-13)

# create annotations in all dashboards

curl -H "Content-Type: application/json" -X POST -d "{\"dashboardId\":1,\"time\":$starttime,\"isRegion\":\"true\",\"timeEnd\":$endtime,\"tags\":[\"mastervertical_117\"],\"text\":\"117 nodes - Mastervertical test - 84 projects\"}" http://admin:admin@dittybopper-dittybopper.apps.test652.myocp4.com/api/annotations
curl -H "Content-Type: application/json" -X POST -d "{\"dashboardId\":2,\"time\":$starttime,\"isRegion\":\"true\",\"timeEnd\":$endtime,\"tags\":[\"mastervertical_117\"],\"text\":\"117 nodes - Mastervertical test - 84 projects\"}" http://admin:admin@dittybopper-dittybopper.apps.test652.myocp4.com/api/annotations
curl -H "Content-Type: application/json" -X POST -d "{\"dashboardId\":3,\"time\":$starttime,\"isRegion\":\"true\",\"timeEnd\":$endtime,\"tags\":[\"mastervertical_117\"],\"text\":\"117 nodes - Mastervertical test - 84 projects\"}" http://admin:admin@dittybopper-dittybopper.apps.test652.myocp4.com/api/annotations
curl -H "Content-Type: application/json" -X POST -d "{\"dashboardId\":4,\"time\":$starttime,\"isRegion\":\"true\",\"timeEnd\":$endtime,\"tags\":[\"mastervertical_117\"],\"text\":\"117 nodes - Mastervertical test - 84 projects\"}" http://admin:admin@dittybopper-dittybopper.apps.test652.myocp4.com/api/annotations

