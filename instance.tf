resource "aws_instance" "vikas" {
  ami                    = "${var.amis}"
  instance_type          = "${var.instancetypes}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${var.sg-id}"]
}

resource "null_resource" "remote-exec-1" {
  connection {
    user        = "${var.user_name}"
    type        = "ssh"
    private_key = "${file(var.pvt_key)}"
    host        = "${aws_instance.vikas.public_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
    ]
  }
}

resource "null_resource" "ansible-main" {
  provisioner "local-exec" {
    command = <<EOT
        sleep 100;
        > jenkins-ci.ini;
        echo "[jenkins-ci]"| tee -a jenkins-ci.ini;
        export ANSIBLE_HOST_KEY_CHECKING=False;
        echo "${aws_instance.vikas.public_ip}" | tee -a jenkins-ci.ini;
    EOT
  }
}
