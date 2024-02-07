resource "aws_instance" "publicinstance" {
  ami                         =  "ami-0c7217cdde317cfec"
  associate_public_ip_address =  true
  availability_zone           =  var.AVAILABILITY_ZONE_NAMES[0] 
  instance_type               = "t2.micro" 
  key_name                    =  "nodejskey"  
  vpc_security_group_ids     = [aws_security_group.instance_security.id] 
  subnet_id                   = aws_subnet.subnets[0].id
  tags = {
    Name = "Jenkins_machine"
  } 
  depends_on = [
    aws_security_group.instance_security
  ]
}

resource "null_resource" "nullresourceforpublic" {
  triggers = {
    running_number  =  "2.0"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = aws_instance.publicinstance.public_ip

  }
  provisioner "file" {
    source      = "./jenkins_install.sh"
    destination = "/tmp/jenkins_install.sh"
  }


  provisioner "remote-exec" {
    inline = [
        "sudo chmod +x /tmp/jenkins_install.sh",
        "sh /tmp/jenkins_install.sh"
    ]
  }
  depends_on = [
    aws_instance.publicinstance
  ]
}