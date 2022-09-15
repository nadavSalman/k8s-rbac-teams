#!/bin/bash


# Create a key and certificate signing request (CSR) for for the teams to access the cluster using openssl :
openssl req -new -newkey rsa:4096 -nodes -keyout team-1-k8s.key -out team-1-k8s.csr -subj "/CN=team-1/O=dev"
openssl req -new -newkey rsa:4096 -nodes -keyout team-2-k8s.key -out team-2-k8s.csr -subj "/CN=team-2/O=dev"
openssl req -new -newkey rsa:4096 -nodes -keyout devops-team-k8s.key -out devops-team-k8s.csr -subj "/CN=devops-team/O=devops"



# Now that we have a CSR, we need to have it signed by the cluster CA.
# Create a CertificateSigningRequest object :
kubectl create –edit -f k8s-csr.yaml


# Next, we want to approve the CSR object, for that we issue the command below:
kubectl certificate approve team-1-k8s-access


# k8s-rbac $ kubectl certificate approve team-1-k8s-access
# certificatesigningrequest.certificates.k8s.io/team-1-k8s-access approved
# k8s-rbac $ kubectl certificate approve team-2-k8s-access
# certificatesigningrequest.certificates.k8s.io/team-2-k8s-access approved
# k8s-rbac $ kubectl get csr
# NAME                AGE     SIGNERNAME                       REQUESTOR       REQUESTEDDURATION   CONDITION
# team-1-k8s-access   2m11s   team-1.hakunamatata.com/team-1   minikube-user   <none>              Approved
# team-2-k8s-access   5m7s    team-2.hakunamatata.com/team-2   minikube-user   <none>              Approved

# That means that Bob’s base64-encoded, signed certificate has been and made available in the ‘status.certificate’ field of the CSR object. 
# To retrieve the certificate, we can issue the following command:


# $ kubectl get csr bob-k8s-access -o jsonpath='{.status.certificate}' | base64 --decode > bob-k8s-access.crt
# work for my minukube configuration :
# $ kubectl get csr team-1-k8s-access -o yaml | yq '.spec.request' | base64 --decode  




