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
resource "aws_security_group" "allow_ssh" {
  name = "allows_ssh"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
  ami = "${data.aws_ami.latest_ami_suitable_for_t2.id}"
  instance_type = "t2.nano"
  key_name = "${aws_key_pair.ssh.key_name}"

  security_groups = ["${aws_security_group.allow_ssh.name}"]

  tags = {
    FromProject = "${var.project_name}"
    Purpose = "${var.project_name}"
  }
}
