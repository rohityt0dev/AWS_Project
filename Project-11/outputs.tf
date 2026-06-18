output "vpc_id" {
  value = aws_vpc.prod_vpc.id
}

output "public_subnet_A" {
  value = aws_subnet.public_A.id
}

output "public_subnet_B" {
  value = aws_subnet.public_B.id
}

output "private_app_A" {
  value = aws_subnet.private_app_A.id
}

output "private_app_B" {
  value = aws_subnet.private_app_B.id
}

output "private_db_A" {
  value = aws_subnet.private_db_A.id
}

output "private_db_B" {
  value = aws_subnet.private_db_B.id
}