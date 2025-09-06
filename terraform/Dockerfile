FROM hashicorp/terraform:1.13

WORKDIR /infra

COPY main.tf .
COPY variables.tf .

ENTRYPOINT ["sh", "-c", "terraform init && terraform apply -auto-approve"]