#!/bin/sh

oc whoami

htpasswd -B -b -c ./htpasswd-users admin openshift
htpasswd -B -b ./htpasswd-users user1 openshift
htpasswd -B -b ./htpasswd-users user2 openshift
htpasswd -B -b ./htpasswd-users user3 openshift
htpasswd -B -b ./htpasswd-users user4 openshift
htpasswd -B -b ./htpasswd-users user5 openshift

oc create secret generic htpasswd-secret --from-file=htpasswd=./htpasswd-users -n openshift-config
oc replace -f ./oauth.yaml

oc adm policy add-cluster-role-to-user cluster-admin admin
oc adm groups new cluster-admins admin
rm -f ./htpasswd-users