# Openshift Gitops Cluster Bootstrap

This project contains a set of ArgoCD manifests used to bootstrap a Openshift Cluster v4.x intended for Developer workflows demo.

It uses the ArgoCD App of Apps pattern to pre-install and configure a set of Openshift Operators to support Developer Workflows.

# Openshift GitOps installation
You can choose to install **Openshift GitOps** Operator manually from the Operator Hub in the Openshift Console (Administrator Perspective) or you can

 1. Authenticate as a `cluster-admin` on your cluster
```
oc apply -f ./openshift-gitops-install/operator.yaml
oc apply -f ./openshift-gitops-install/argocd.yaml
```

 2. Apply additional `ClusterRoleBindings` to ArgoCD Controller Service Accounts
```
oc apply -f ./openshift-gitops-install/rbac.yaml
```

 3. **IMPORTANT**: Make your cluster admin(s) ArgoCD Admins
```
oc adm groups new cluster-admins <your admin username here>
```

### Manual steps

This demo is based on GitHub. Create an github org that you'll use with this demo and add a couple of teams.
It requires some manual preparation steps for tasks that do not seem automate-able on GitHub (at least i was no able to automate them).

1. create a new organization or reuse an existing one.
2. create an Oauth app (under 'Developer Settings') in this organization for OpenShift Dev Spaces. The call back url should be `https://devspaces.apps.${base_domain}/api/oauth/callback`
3. create an Oauth app in this organization for OpenShift. The call back url should be `https://oauth-openshift.apps.${base_domain}/oauth2callback/github`
4. create a Personal Access Token (PAT) with an account that is administrator to the chosen organization.

Create a client secret for each of the OAuth apps.

Create a file called `secrets.sh` and store it at the top of this repo, it will be ignored by Git.

```shell
export github_organization=<org_name>

export devspaces_github_client_id=<devspaces_oauth_app_id>
export devspaces_github_client_secret=<devspaces_oauth_app_secret>

export ocp_github_client_id=<ocp_oauth_app_id>
export ocp_github_client_secret=<ocp_oauth_app_secret>
export org_admin_pat=<pat token>
```

now you can source the file and populate the environment variables any time:

```shell
source ./secrets.sh
```

Run the following commands to populate the Kubernetes secrets with the previously generated values (this is fine for a demo, it might not be fine for a production environment):

```shell
oc create namespace openshift-devspaces
oc create secret generic github-oauth-config --from-literal=id=${devspaces_github_client_id} --from-literal=secret=${devspaces_github_client_secret} -n openshift-devspaces
oc label secret github-oauth-config -n openshift-devspaces --overwrite=true app.kubernetes.io/part-of=che.eclipse.org app.kubernetes.io/component=oauth-scm-configuration
oc annotate secret github-oauth-config -n openshift-devspaces --overwrite=true che.eclipse.org/oauth-scm-server=github
oc create secret generic ocp-github-app-credentials -n openshift-config --from-literal=client_id=${ocp_github_client_id} --from-literal=clientSecret=${ocp_github_client_secret} --from-literal=orgs=${github_organization}
```

## Openshift DevSpaces configs

```
oc create namespace openshift-devspaces
oc create secret generic github-oauth-config --from-literal=id=${devspaces_github_client_id} --from-literal=secret=${devspaces_github_client_secret} -n openshift-devspaces
oc label secret github-oauth-config -n openshift-devspaces --overwrite=true app.kubernetes.io/part-of=che.eclipse.org app.kubernetes.io/component=oauth-scm-configuration
oc annotate secret github-oauth-config -n openshift-devspaces --overwrite=true che.eclipse.org/oauth-scm-server=github
oc create secret generic ocp-github-app-credentials -n openshift-config --from-literal=client_id=${ocp_github_client_id} --from-literal=clientSecret=${ocp_github_client_secret}
```