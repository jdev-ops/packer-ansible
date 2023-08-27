
packer {
  required_plugins {
    docker = {
      source  = "github.com/hashicorp/docker"
      version = "~> 1"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}

variable "dockerhub_username" {
  type = string
}

variable "dockerhub_password" {
  type = string
}

source "docker" "docker-source" {

    changes = [
      "USER root",
      "ENTRYPOINT [\"/init\"]",
      "EXPOSE 8200",
      "ENV VAULT_API_ADDR \"http://127.0.0.1:8300\"",
      "ENV VAULT_ADDR \"http://127.0.0.1:8300\"",
      "ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME 10000",
      "ENV UNSEAL_KEY \"PHWRdRkRj96fsF4MiWtVn4C3xLWAlAbHKYBWtY747nE=\"",
      "ENV INITIAL_ROOT_TOKEN \"hvs.i2dp3c46t5WARYsQfeppbDkR\"",
    ]
  commit  = true
  image   = "docker.io/jalbert/ubuntu-basic:22.04"
}

build {
  sources = ["source.docker.docker-source"]

  provisioner "ansible" {
    ansible_env_vars = [
      "ANSIBLE_DISTRIBUTION=debian",
      "ANSIBLE_PIPELINING=true",
    ]
    extra_arguments  = ["-vvvv", "--ssh-extra-args", "-o IdentitiesOnly=yes -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa"] # Make ansible and ssh client very verbose
    playbook_file    = "provision-vault.yml"
    user             = "root"
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "docker.io/jalbert/vault"
      tags        = ["1.14.1"]
      force = true
    }
    post-processor "docker-push" {
      login = true
      login_username = var.dockerhub_username
      login_password = var.dockerhub_password
    }
  }
}
