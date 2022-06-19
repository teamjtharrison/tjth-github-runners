## Webserver
resource "aws_security_group" "this" {
  name        = "${var.runner_name}-sg"
  description = "Security group for ${var.runner_name}"

  dynamic "ingress" {
    for_each = local.ingress_ports
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      cidr_blocks = ingress.value["cidrs"]
      protocol    = "tcp"
      description = ingress.value["description"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = "${var.runner_name}-sg"
  }
}

resource "aws_instance" "this" {
  ami           = "ami-00c90dbdc12232b58"
  instance_type = var.instance_type
  vpc_security_group_ids = [
    "${aws_security_group.this.id}"
  ]
  key_name = "tjth-key"
  tags = {
    Name = "${var.runner_name}"
  }

  iam_instance_profile = aws_iam_instance_profile.this.id

  root_block_device {
    volume_size = 30
    encrypted   = true
  }

  metadata_options {
    http_put_response_hop_limit = 2
    http_endpoint               = "enabled"
    http_tokens                 = "required"
  }

  user_data = <<EOF
#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

  sudo apt-get update
  sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    python3-pip
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin jq awscli

  aws configure set default.region eu-west-1
  # Setup runner 
  mkdir /home/ubuntu/actions-runner
  cd /home/ubuntu/actions-runner
  curl -o actions-runner-linux-x64-2.292.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.292.0/actions-runner-linux-x64-2.292.0.tar.gz
  echo "14839ba9f3da01abdd51d1eae0eb53397736473542a8fae4b7618d05a5af7bb5  actions-runner-linux-x64-2.292.0.tar.gz" | shasum -a 256 -c
  tar xzf ./actions-runner-linux-x64-2.292.0.tar.gz
  chown -R ubuntu:ubuntu /home/ubuntu/actions-runner
  sudo -u ubuntu bash -c "/home/ubuntu/actions-runner/config.sh --url ${var.github_team_url} --token $(aws ssm get-parameter --name github_runner_token --with-decryption | jq -r '.Parameter.Value')"
  sudo -u ubuntu bash -c "/home/ubuntu/actions-runner/run.sh"
EOF
}
