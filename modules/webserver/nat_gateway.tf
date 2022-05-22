# resource "aws_eip" "training-nat-eip" {
#   vpc      = true
# }

# # NAT Gateway
# resource "aws_eip_association" "eip_assoc" {
#   instance_id   = aws_instance.terraform-server.id
#   allocation_id = aws_eip.training-eip.id
# }
# resource "aws_nat_gateway" "training" {
#   allocation_id = aws_eip.training-nat-eip.id
#   subnet_id     = aws_subnet.public-1a.id

#   tags = {
#     Name = "training-NAT"
#   }

#   depends_on = [aws_internet_gateway.training]
# }