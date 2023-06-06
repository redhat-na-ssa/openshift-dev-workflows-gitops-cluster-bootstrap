#!/bin/bash

clear
echo
# for OCP

#Go to https://github.com/settings/applications/new
#Enter the 'Red HAt DevSpaces Demo' as the Application Name
#Enter the Homepage URL as 'https://console-openshift-console.apps.cluster-domain/'
#Enter the Authorization callback URL as 'https://oauth-openshift.apps.cluster-domain/oauth2callback/github'
#Remember to copy the Client Id and the Client Secret values

echo
read -e -p "Enter a : " NAMESPACE
# [[ -z $NAMESPACE ]] && echo "Project namespace required" && exit 1

#client_id=
#client_secret=
#orgs=
oc delete secret ocp-github-app-credentials -n openshift-config
oc create secret generic ocp-github-app-credentials -n openshift-config \
--from-literal=client_id= \
--from-literal=clientSecret= \
--from-literal=orgs=

#for DevSpaces

#Go to https://github.com/settings/applications/new
#Enter the 'Red HAt DevSpaces Demo' as the Application Name
#Enter the Homepage URL as 'https://devspaces.apps.cluster-domain/'
#Enter the Authorization callback URL as 'https://devspaces.apps.cluster-domain/api/oauth/callback'
#Remember to copy the Client Id and the Client Secret values

#client_id=
#client_secret=
oc delete secret devspaces-github-app-credentials -n openshift-devspaces
oc create secret generic devspaces-github-app-credentials -n openshift-config \
--from-literal=client_id= \
--from-literal=clientSecret=

oc label secret devspaces-github-app-credentials -n openshift-devspaces \
--overwrite=true app.kubernetes.io/part-of=che.eclipse.org app.kubernetes.io/component=oauth-scm-configuration
oc annotate secret devspaces-github-app-credentials -n openshift-devspaces \
--overwrite=true che.eclipse.org/oauth-scm-server=github