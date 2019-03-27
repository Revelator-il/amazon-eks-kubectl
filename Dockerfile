FROM alpine:latest

ADD https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/kubectl /usr/local/bin/kubectl
ADD https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator /usr/local/bin/aws-iam-authenticator
RUN set -x && \
    \
    apk add --update --no-cache curl ca-certificates python py-pip jq && \
    chmod +x /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/aws-iam-authenticator && \
    \
    # Create non-root user (with a randomly chosen UID/GUI).
    adduser kubectl -Du 2342 && \
    \
    # Install AWS CLI
    pip install --upgrade awscli && \
    # Basic check it works.
    aws --version && kubectl version --client

USER kubectl
CMD aws eks --region $AWS_DEFAULT_REGION update-kubeconfig --name $CLUSTER && kubectl get svc
ENTRYPOINT []