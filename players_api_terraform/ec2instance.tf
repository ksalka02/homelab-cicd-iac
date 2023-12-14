# resource "aws_instance" "players_api_instance" {
#   ami                    = "ami-03a6eaae9938c858c"
#   instance_type          = "t2.micro"
#   vpc_security_group_ids = [aws_security_group.players_api.id]
#   key_name               = "api_test_key"
#   user_data              = file("../players_userdata.sh")
#   tags = {
#     Name = "players"
#   }
# }

# resource "aws_instance" "moreinfo_api_instance" {
#   ami                    = "ami-03a6eaae9938c858c"
#   instance_type          = "t2.micro"
#   vpc_security_group_ids = [aws_security_group.players_api.id]
#   key_name               = "api_test_key"
#   user_data              = file("../moreinfo_userdata.sh")
#   tags = {
#     Name = "moreinfo"
#   }
# }