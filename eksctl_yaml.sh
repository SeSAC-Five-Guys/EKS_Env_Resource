#!/bin/bash
# command ./eksctl_shell.sh
# eksctl yaml 실행

source ~/.bash_profile
cat << EOF > ~/environment/myeks/mjtest2.yaml
---
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: ${ekscluster_name}
  region: ${AWS_REGION}
  version: "${eks_version}"  
vpc: 
  id: ${vpc_ID}
  subnets:
    public:
      PublicSubnet01:
        az: ${AWS_REGION}a
        id: ${PublicSubnet01}
      PublicSubnet02:
        az: ${AWS_REGION}b
        id: ${PublicSubnet02}
      PublicSubnet03:
        az: ${AWS_REGION}c
        id: ${PublicSubnet03}
    private:
      PrivateSubnet01:
        az: ${AWS_REGION}a
        id: ${PrivateSubnet01}
      PrivateSubnet02:
        az: ${AWS_REGION}b
        id: ${PrivateSubnet02}
      PrivateSubnet03:
        az: ${AWS_REGION}c
        id: ${PrivateSubnet03}
secretsEncryption:
  keyARN: ${MASTER_ARN}

managedNodeGroups:
  - name: managed-ng-private-01
    instanceType: ${instance_type}
    subnets:
      - ${PrivateSubnet01}
      - ${PrivateSubnet02}
      - ${PrivateSubnet03}
    desiredCapacity: 3
    privateNetworking: true
    minSize: 3
    maxSize: 9
    volumeSize: 200
    volumeType: gp3
    volumeEncrypted: true
    amiFamily: AmazonLinux2
    labels:
      nodegroup-type: "${private_mgmd_node}"
    ssh: 
      publicKeyPath: "${publicKeyPath}"
    iam:
      attachPolicyARNs:
      withAddonPolicies:
        autoScaler: true
        cloudWatch: true
        ebs: true
        fsx: true
        efs: true        
cloudWatch:
    clusterLogging:
        enableTypes: ["api", "audit", "authenticator", "controllerManager", "scheduler"]
iam:
  withOIDC: true
addons:
- name: vpc-cni
  attachPolicyARNs:
    - arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy
- name: coredns
  version: latest
- name: kube-proxy
  version: latest
- name: aws-ebs-csi-driver
  wellKnownPolicies:
    ebsCSIController: true
EOF
