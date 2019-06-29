locals {
  temp_private_key_file = "./temp-private-key.pem"
}

# SSH key
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh" {
  key_name   = "${var.project_name}-ssh-${terraform.workspace}"
  public_key = "${tls_private_key.ssh.public_key_openssh}"
}

# EC2 instance
resource "aws_security_group" "starbound_server" {
  name = "starbound_server"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 21025
    to_port = 21025
    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 21025
    to_port = 21025
    protocol = "udp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
  ami = "${data.aws_ami.latest_ami_suitable_for_t2.id}"
  instance_type = "t2.nano"
  key_name = "${aws_key_pair.ssh.key_name}"

  security_groups = ["${aws_security_group.starbound_server.name}"]

  tags = {
    Name = "${var.project_name}"
    FromProject = "${var.project_name}"
    Purpose = "${var.project_name}"
  }

  provisioner "local-exec" {
    command =<<EOF
      echo "${tls_private_key.ssh.private_key_pem}" > "${local.temp_private_key_file}" && chmod 600 "${local.temp_private_key_file}"
      sleep 30 && ansible-playbook --user ubuntu --inventory '${aws_instance.ec2.public_ip},' ./ansible/install-steamcmd.yml
    EOF

    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
      ANSIBLE_PRIVATE_KEY_FILE = "${local.temp_private_key_file}"
    }
  }
}
